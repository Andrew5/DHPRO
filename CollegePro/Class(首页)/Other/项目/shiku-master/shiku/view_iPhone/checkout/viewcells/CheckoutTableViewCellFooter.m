//
//  CartTableViewCellFooter.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CheckoutTableViewCellFooter.h"

@implementation CheckoutTableViewCellFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cellRect = self.frame;
    CGContextSetFillColorWithColor(context, BG_COLOR.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, shop_item)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
//共计费用
-(void)render
{
    self.totalCount.text=[NSString stringWithFormat:@"共%ld件商品",(long)self.shop_item.cart_goods_list.count];
//    float totalPrice=0;
//    for (CART_GOODS *cg in self.shop_item.cart_goods_list) {
//        totalPrice+=cg.goods_price;
//    }
//    self.totalPrice.text=[NSString stringWithFormat:@"合计:￥%.2f",totalPrice];
}


@end
