//
//  CartTableViewCellFooter.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderListTableViewCellFooter.h"

@implementation OrderListTableViewCellFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect cellRect = self.frame;
    CGContextSetFillColorWithColor(context, BG_COLOR.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
    self.btnQFK.layer.cornerRadius=5;
    [self.btnQFK setTintColor:MAIN_COLOR];
    self.btnQFK.layer.borderColor=MAIN_COLOR.CGColor;
    self.btnQFK.layer.borderWidth=1;
    
    self.btnGBJY.layer.cornerRadius=5;
    [self.btnGBJY setTintColor:TEXT_COLOR_DARK];
    self.btnGBJY.layer.borderColor=TEXT_COLOR_DARK.CGColor;
    self.btnGBJY.layer.borderWidth=1;
    
    self.btnCKXQ.layer.cornerRadius=5;
    [self.btnCKXQ setTintColor:TEXT_COLOR_DARK];
    self.btnCKXQ.layer.borderColor=TEXT_COLOR_DARK.CGColor;
    self.btnCKXQ.layer.borderWidth=1;
    
    self.btnQRSH.layer.cornerRadius=5;
    [self.btnQRSH setTintColor:MAIN_COLOR];
    self.btnQRSH.layer.borderColor=MAIN_COLOR.CGColor;
    self.btnQRSH.layer.borderWidth=1;
    
    self.btnCKWL.layer.cornerRadius=5;
    [self.btnCKWL setTintColor:TEXT_COLOR_DARK];
    self.btnCKWL.layer.borderColor=TEXT_COLOR_DARK.CGColor;
    self.btnCKWL.layer.borderWidth=1;
    
    self.btnSCDD.layer.cornerRadius=5;
    [self.btnSCDD setTintColor:TEXT_COLOR_DARK];
    self.btnSCDD.layer.borderColor=TEXT_COLOR_DARK.CGColor;
    self.btnSCDD.layer.borderWidth=1;
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, order)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
-(void)render
{
    self.totalCount.text=[NSString stringWithFormat:@"共%ld件商品",(long)self.order.shop_item.cart_goods_list.count];
    float totalPrice=0;
    for (CART_GOODS *cg in self.order.shop_item.cart_goods_list) {
        totalPrice+=cg.goods_price;
    }
    self.totalFreight.text=[NSString stringWithFormat:@"￥%@",self.order.formated_shipping_fee];
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",totalPrice];
    
    if ([self.order.order_info.order_status isEqualToString:@"0"]) {
        [self.btnQFK setHidden:NO];
        self.ckxqMarginRight.constant=100;
//        [self.btnCKXQ setHidden:NO];
        [self.btnCKWL setHidden:YES];
        [self.btnQRSH setHidden:YES];
        [self.btnSCDD setHidden:YES];
    }
    else if ([self.order.order_info.order_status isEqualToString:@"1"]) {
        [self.btnQFK setHidden:YES];
//        [self.btnCKXQ setHidden:NO];
        [self.btnGBJY setHidden:YES];
        [self.btnCKWL setHidden:YES];
        [self.btnQRSH setHidden:YES];
        [self.btnSCDD setHidden:YES];
    }
    else if ([self.order.order_info.order_status isEqualToString:@"2"]) {
        [self.btnQFK setHidden:YES];
        self.ckxqMarginRight.constant=190;
//        [self.btnCKXQ setHidden:YES];
        [self.btnGBJY setHidden:YES];
        [self.btnCKWL setHidden:NO];
        [self.btnQRSH setHidden:NO];
        [self.btnSCDD setHidden:YES];
    }
    else if ([self.order.order_info.order_status isEqualToString:@"4"]) {
        [self.btnQFK setHidden:YES];
        self.ckxqMarginRight.constant=10;
        //        [self.btnCKXQ setHidden:YES];
        [self.btnGBJY setHidden:YES];
        [self.btnCKWL setHidden:NO];
        [self.btnQRSH setHidden:YES];
        [self.btnSCDD setHidden:YES];
    }
    else if ([self.order.order_info.order_status isEqualToString:@"5"]) {
        [self.btnQFK setHidden:YES];
        //        [self.btnCKXQ setHidden:NO];
        [self.btnGBJY setHidden:YES];
        [self.btnCKWL setHidden:YES];
        [self.btnQRSH setHidden:YES];
        [self.btnSCDD setHidden:YES];
    }
    else {
        [self.btnQFK setHidden:YES];
//        [self.btnCKXQ setHidden:NO];
        [self.btnGBJY setHidden:YES];
        [self.btnCKWL setHidden:NO];
        [self.btnQRSH setHidden:YES];
        [self.btnSCDD setHidden:YES];
    }
}

//确认收货
- (IBAction)btnQRSHTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didQRSHTaped:)])
    {
        [self.delegate didQRSHTaped:self.order];
    }
}
//查看物流
- (IBAction)btnCKWLTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCKWLTaped:)])
    {
        [self.delegate didCKWLTaped:self.order];
    }
}
//提醒发货
- (IBAction)btnCKXQTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCKXQTapped:)])
    {
        [self.delegate didCKXQTapped:self.order];
    }
}
//去付款
- (IBAction)btnQFKTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didQFKTaped:)])
    {
        [self.delegate didQFKTaped:self.order];
    }
}
//删除订单
- (IBAction)btnSCDDTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSCDDTaped:)])
    {
        [self.delegate didQRSHTaped:self.order];
    }
}
//关闭交易订单
- (IBAction)btnGBJYTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didGBJYTaped:)])
    {
        [self.delegate didGBJYTaped:self.order];
    }
}
@end
