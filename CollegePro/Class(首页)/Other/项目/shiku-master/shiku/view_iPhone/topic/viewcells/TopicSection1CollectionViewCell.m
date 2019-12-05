//
//  TopicSection2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/5/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TopicSection1CollectionViewCell.h"

@implementation TopicSection1CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.coverImageViewHeight.constant=self.frame.size.width/2.0f;
    
    self.priceLabel1.textColor=MAIN_COLOR;
    self.priceLabel2.textColor=TEXT_COLOR_DARK;
    self.priceLabel3.textColor=TEXT_COLOR_DARK;
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, category)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}
- (void)render
{
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.category.img.small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
      [self.coverImageView2 sd_setImageWithURL:[NSURL URLWithString:self.category.img.img] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.titleLabel1.text=self.category.name;
    self.priceLabel1.text=[NSString stringWithFormat:@"￥%@",
                           self.category.value];
    self.priceLabel2.text=@"";
    self.priceLabel3.text=@"";
}

@end
