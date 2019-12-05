//
//  Cart.m
//  shiku
//
//  Created by txj on 15/5/12.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Cart.h"
#import "AppDelegate.h"
@implementation Cart
//-(instancetype)init
//{
//    self=[super init];
//    if (self) {
//        @weakify(self)
//        [RACObserve(self, select_shop_list)
//         subscribeNext:^(id x) {
//             @strongify(self);
//            
//         }];
//    }
//    return self;
//}
+ (instancetype)shared
{
    static Cart *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
        _shared.select_shop_list=[[NSMutableDictionary alloc] init];
        _shared.shop_list=[[NSMutableArray alloc] init];
        _shared.total=[[TOTAL alloc] init];
       _shared.Num = [_shared getCartNums];
    });
    return _shared;
}
- (NSInteger)getCartNums
{
    
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    if ([App shared].currentUser==nil) {
        return 0;
    }
    NSNumber *cartNums = [myUser objectForKey:[App shared].currentUser.token];
    NSInteger num = [cartNums integerValue];
    if (num<0) {
        num=0;
    }
    return num;
    
}
+ (void)AddNumWithGoodsNum:(NSInteger)goodNums;
{
    [Cart shared].Num = [Cart shared].Num+goodNums;
    [Cart changeState];
}
+ (void)MinusNumWithGoodsnum:(NSInteger)goodNum
{
    [Cart shared].Num = [Cart shared].Num-goodNum;
    if ([Cart shared].Num<0) {
        [Cart clearCart];
    }
    [Cart changeState];
}
+ (void)clearCartNums
{
    [Cart shared].Num=0;
    [Cart changeState];
}
+ (void)saveCartNum
{
    NSInteger num = [Cart shared].Num<0?0:[Cart shared].Num;
    NSUserDefaults *myUser = [NSUserDefaults standardUserDefaults];
    if ([App shared].currentUser.token) {
         [myUser setObject:[NSNumber numberWithInteger:num] forKey:[App shared].currentUser.token];
    }
   
    [myUser synchronize];
    [Cart changeState];
    
}
+ (void)changeState
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView*view =(UIView*)delegate.viewController.tabBar.subviews[2];
    UILabel *bageLab = (UILabel*)view.subviews[0];
    NSInteger bageNum =[Cart shared].Num;
  
    if (bageNum>0) {
        bageLab.hidden = NO;
        bageNum = bageNum>99?99:bageNum;
        bageLab.text =[NSString stringWithFormat:@"%ld",(long)bageNum ];
        
    }else
    {
        bageLab.hidden = YES;
    }
}
-(int)getTotalAmount
{
    int total=0;
    for (SHOP_ITEM *item in self.shop_list) {
//        for (CART_GOODS *cd in item.cart_goods_list) {
//            total+=cd.goods_number;
//        }
        total+=item.cart_goods_list.count;
    }
    return total;
}

#pragma mark 获取选中商品的总价
-(void)wantTotal
{
    self.checkout_shop_list=[[NSMutableArray alloc] init];
    int totalCount=0;
    float totalPrice=0;
    float totalWeight=0;
    for (NSString *key in self.select_shop_list.allKeys) {
        SHOP_ITEM *item= [self.select_shop_list objectForKey:key];
        [self.checkout_shop_list addObject:item];
        totalCount+= item.cart_goods_list.count;
        for (CART_GOODS *cd in item.cart_goods_list) {
            totalWeight+=cd.goods_weight*cd.goods_number;
            totalPrice+=cd.goods_price*cd.goods_number;
        }
        
    }
    self.total.goods_weight=[NSString stringWithFormat:@"%.2f",totalWeight];
    self.total.goods_price=[NSString stringWithFormat:@"%.2f",totalPrice];
    self.total.goods_amount=[NSString stringWithFormat:@"%d",totalCount];
}

#pragma mark 全部选中购物车
-(void)selectAllItems
{
    int totalCount=0;
    float totalPrice=0;
    float totalWeight=0;
    self.checkout_shop_list=[[NSMutableArray alloc] init];
    int i=0;
    for (SHOP_ITEM *item in self.shop_list) {
        totalCount+= item.cart_goods_list.count;
        item.isSeleced=YES;
        NSString *key=[NSString stringWithFormat:@"%d",i];
        SHOP_ITEM *gl;
        gl=[self.select_shop_list objectForKey:key];
        [self.checkout_shop_list addObject:item];
        if (!gl) {
            gl=[[SHOP_ITEM alloc] init];
            gl.name=item.name;
            gl.rec_id=item.rec_id;
            gl.cart_goods_list=[[NSMutableArray alloc] init];
            [self.select_shop_list setObject:gl forKey:key];
        }

        
        [self.select_shop_list setObject:gl forKey:key];
        for (CART_GOODS *cg in item.cart_goods_list) {
            totalPrice+=cg.goods_price*cg.goods_number;
            totalWeight+=cg.goods_weight*cg.goods_number;
            cg.isSeleced=YES;
            if (![gl.cart_goods_list containsObject:cg]) {
                [gl.cart_goods_list addObject:cg];
            }
        }
        i++;
    }
    self.total.goods_weight=[NSString stringWithFormat:@"%.2f",totalWeight];
    self.total.goods_price=[NSString stringWithFormat:@"%.2f",totalPrice];
    self.total.goods_amount=[NSString stringWithFormat:@"%d",totalCount];
}

#pragma mark 全部取消选中
-(void)removeAllSelectItems
{
    int i=0;
    [self.checkout_shop_list removeAllObjects];
    for (SHOP_ITEM *item in self.shop_list) {
        item.isSeleced=NO;
        [self.select_shop_list removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
        for (CART_GOODS *cd in item.cart_goods_list) {
            cd.isSeleced=NO;
//            item.select_count--;
        }
        i++;
    }
    self.total.goods_price=@"0.00";
    self.total.goods_amount=@"0";
    self.total.goods_weight=@"0.00";
}

#pragma mark 判断购物车是否全部选中
-(BOOL)isAllItemsSelected
{
    BOOL alflag=YES;
    if (self.shop_list.count==self.select_shop_list.count) {
        for (int i=0; i<self.shop_list.count; i++) {
            SHOP_ITEM *s1=[self.shop_list objectAtIndex:i];
            SHOP_ITEM *s2=[self.select_shop_list objectForKey:[NSString stringWithFormat:@"%d",i]];
            if (s1.cart_goods_list.count!=s2.cart_goods_list.count) {
                alflag=NO;
                break;
            }
        }
    }
    else {
        alflag=NO;
    }

    return alflag;
}
+(void)clearCart
{
    [Cart clearCartNums];
    [[[self shared] shop_list] removeAllObjects];
    [[[self shared] checkout_shop_list] removeAllObjects];
    [[[self shared] select_shop_list] removeAllObjects];
    [[[self shared] payment_list] removeAllObjects];
    [[[self shared] shipping_list] removeAllObjects];
}
@end
