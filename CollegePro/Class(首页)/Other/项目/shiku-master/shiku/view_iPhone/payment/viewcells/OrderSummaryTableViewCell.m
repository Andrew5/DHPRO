//
//  OrderSummaryTableViewCell.m
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderSummaryTableViewCell.h"

@implementation OrderSummaryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=WHITE_COLOR;
//    self.orderIdLabel.textColor=WHITE_COLOR;
//    self.orderFreightLabel.textColor=WHITE_COLOR;
//    self.orderPriceLabel.textColor=WHITE_COLOR;
    
    _orderIView.layer.borderColor = [UIColor grayColor].CGColor;
    _orderIView.layer.borderWidth = 0.3;
    
    _orderIIView.layer.borderColor = [UIColor grayColor].CGColor;
    _orderIIView.layer.borderWidth = 0.3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
- (void)render
{
//    self.orderPriceLabel.text =[NSString stringWithFormat:@"订单金额（含运费）：￥%@元",self.order.order_info.total_fee];
    self.orderPriceLabel.text =[NSString stringWithFormat:@"￥%@元",self.order.order_info.total_fee];

//    self.orderIdLabel.text =[NSString stringWithFormat:@"订单编号：%@",self.order.order_info.order_id];
    self.orderIdLabel.text =[NSString stringWithFormat:@"订单编号：%@",self.order.order_info.order_id];

//    self.orderFreightLabel.text =[NSString stringWithFormat:@"运费：￥%@元",self.order.formated_shipping_fee];
    self.orderFreightLabel.text =[NSString stringWithFormat:@"￥%@元",self.order.formated_shipping_fee];

    
//        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",
//                                self.cartItem.goods_price];
//    
//        self.quantityLabel.text=[NSString stringWithFormat:@"x%ld",(long)self.cartItem.goods_number];
//        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];
}

@end
