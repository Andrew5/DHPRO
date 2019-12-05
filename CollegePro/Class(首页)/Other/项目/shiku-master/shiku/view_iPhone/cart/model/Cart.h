//
//  Cart.h
//  shiku
//
//  Created by txj on 15/5/12.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"

@interface Cart : NSObject
@property (strong, nonatomic) NSMutableArray* shop_list;//SHOP_ITEM
@property (strong, nonatomic) TOTAL* total;
@property (nonatomic, retain) NSNumber* goods_num;
// 结算（提交订单前的订单预览）
@property (strong, nonatomic) NSNumber* couponId;
@property (retain, nonatomic) NSMutableDictionary* select_shop_list;//SHOP_ITEM
@property (strong, nonatomic) NSMutableArray* checkout_shop_list;//SHOP_ITEM
@property (strong, nonatomic) NSMutableArray* payment_list;
@property (strong, nonatomic) NSMutableArray* shipping_list;
@property (strong, nonatomic) ADDRESS* address;
@property (nonatomic,assign) NSInteger Num;
+ (instancetype)shared;
+(void)clearCart;
+ (void)AddNumWithGoodsNum:(NSInteger)goodNums;
+ (void)MinusNumWithGoodsnum:(NSInteger)goodNum;
+ (void)clearCartNums;
+ (void)saveCartNum;
+ (void)changeState;
-(int)getTotalAmount;
-(void)wantTotal;
-(void)selectAllItems;
-(void)removeAllSelectItems;
-(BOOL)isAllItemsSelected;
- (NSInteger)getCartNums;
@end
