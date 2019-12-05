//
//  FavTableViewCell.m
//  btc
//
//  Created by txj on 15/3/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.coverImageWidth.constant=self.coverImage.frame.size.height;
    self.titleLabel.textColor=TEXT_COLOR_BLACK;
//    self.shopname.textColor=TEXT_COLOR_BLACK;
//    self.subtitle1.textColor=TEXT_COLOR_DARK;
    self.subtitle2.textColor=TEXT_COLOR_DARK;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, goods)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}
- (void)render
{
//    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.goods.img.small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.shopname.text=[NSString stringWithFormat:@"￥%@",self.goods.shop_price];
    self.subtitle1.text=[NSString stringWithFormat:@"满%@使用",self.goods.shop_name];
    self.subtitle2.text=[NSString stringWithFormat:@"有效期至：%@",self.goods.sub_title2];
    //    self.quantityLabel.text=[NSString stringWithFormat:@"%.2fkg",[self.goods.goods_weight floatValue]];
    self.titleLabel.text=self.goods.name;
    [self.titleLabel alignTop];
}


@end
