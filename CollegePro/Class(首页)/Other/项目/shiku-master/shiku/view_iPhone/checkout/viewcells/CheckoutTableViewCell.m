//
//  CartTableViewCell.m
//  btc
//
//  Created by txj on 15/3/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CheckoutTableViewCell.h"
#import <XZFramework/UIImage+Resize.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <XZFramework/TAlertView.h>

@implementation CheckoutTableViewCell

- (void)awakeFromNib {
    // Initialization code

    self.coverImageWidth.constant=self.coverImage.frame.size.height*2;
    self.titleLabel.userInteractionEnabled=YES;
//    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCartItemTitleTaped)];
    //self.titleLabel.textColor=TEXT_COLOR_DARK;
//    [self.titleLabel addGestureRecognizer:tapGesture];
    
    self.quantityLabel.textColor=TEXT_COLOR_DARK;
    self.subTitleLabel.textColor=TEXT_COLOR_DARK;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)bind
{
    @weakify(self)
    [RACObserve(self, cartItem)
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
    self.titleLabel.text = self.cartItem.goods_name;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",
                       self.cartItem.goods_price];
    
    self.quantityLabel.text=[NSString stringWithFormat:@"x%ld",(long)self.cartItem.goods_number];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.cartItem.img.small] placeholderImage:img_placehold];
    self.subTitleLabel.text=[NSString stringWithFormat:@"规格：%@",!self.cartItem.goods_strattr?self.cartItem.goods_strattr:@"默认"];
}


@end
