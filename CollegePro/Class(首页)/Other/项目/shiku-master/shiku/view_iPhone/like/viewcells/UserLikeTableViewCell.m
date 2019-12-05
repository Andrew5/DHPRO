//
//  UserLikeTableViewCell.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserLikeTableViewCell.h"

@implementation UserLikeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.coverImageWidth.constant=self.coverImage.frame.size.height*coverimagewidth;
    self.titleLabel.textColor=TEXT_COLOR_BLACK;
//    self.priceLabel.textColor=MAIN_COLOR;
    
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
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.goods.img.small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",[self.goods.shop_price floatValue]];
    
//    self.quantityLabel.text=[NSString stringWithFormat:@"%.2fkg",[self.goods.goods_weight floatValue]];
    self.titleLabel.text=self.goods.name;
    [self.titleLabel alignTop];
    [self.priceLabel alignBottom];
}

- (IBAction)btnSharedTapped:(id)sender {
    if ([self.ulDelegate respondsToSelector:@selector(didSharedBtnTapped:)]) {
        [self.ulDelegate didSharedBtnTapped:self.goods];
    }
}
@end
