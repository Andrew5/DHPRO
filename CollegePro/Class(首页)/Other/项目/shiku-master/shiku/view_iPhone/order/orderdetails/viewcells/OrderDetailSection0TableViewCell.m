//
//  OrderDetailSection0TableViewCell.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderDetailSection0TableViewCell.h"

@implementation OrderDetailSection0TableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=MAIN_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)bind
{
    @weakify(self)
    [RACObserve(self, order)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}
-(void)unbind
{
}
- (void)render
{
    self.freightStatus.text=self.order.order_info.order_sstatus;
    self.orderPrice.text=[NSString stringWithFormat:@"订单金额（含运费）:￥%@元",self.order.order_info.total_fee];
    self.freight.text=[NSString stringWithFormat:@"运费:￥%@元",self.order.formated_shipping_fee];
//    self.titleLabel.text = self.cartItem.goods_name;
//    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",
//                            self.cartItem.goods_price];
//    
//    self.quantityLabel.text=[NSString stringWithFormat:@"x%ld",(long)self.cartItem.goods_number];
//    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];
}

@end
