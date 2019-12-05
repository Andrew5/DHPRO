//
//  OrderDetailSection0TableViewCell.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "ViewLogisticsTableViewCell.h"

@implementation ViewLogisticsTableViewCell

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
    self.freightStatus.text=self.order.shipping_item.shipping_name;
    self.orderPrice.text=[NSString stringWithFormat:@"快递单号:%@",self.order.shipping_item.shipping_sn];
    self.freight.text=[NSString stringWithFormat:@"备注说明:￥%@元",self.order.shipping_item.shipping_desc];
//    self.titleLabel.text = self.cartItem.goods_name;
//    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",
//                            self.cartItem.goods_price];
//    
//    self.quantityLabel.text=[NSString stringWithFormat:@"x%ld",(long)self.cartItem.goods_number];
//    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];
}

@end
