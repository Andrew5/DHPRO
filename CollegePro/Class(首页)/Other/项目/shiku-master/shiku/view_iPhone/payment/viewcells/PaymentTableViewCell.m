//
//  PaymentTableViewCell.m
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCellContent:(NSString *)text withImageName:(NSString *)imagename
{
    self.coverImageView.image=[UIImage imageNamed:imagename];

    self.nameLabel.text=text;
}

- (void)bind
{
    @weakify(self)
    [RACObserve(self, orderInfo)
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
//    self.titleLabel.text = self.cartItem.goods_name;
//    
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",
//                            self.cartItem.goods_price];
//    
//    self.quantityLabel.text=[NSString stringWithFormat:@"x%ld",(long)self.cartItem.goods_number];
//    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];
}


@end
