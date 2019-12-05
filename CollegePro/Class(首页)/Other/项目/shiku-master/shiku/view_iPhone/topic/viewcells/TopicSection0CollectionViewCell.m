//
//  TopicSection0CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/5/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TopicSection0CollectionViewCell.h"

@implementation TopicSection0CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel1.textColor=TEXT_COLOR_DARK;
    [self.titleLabel1 alignTop];
    self.coverImageViewHeight.constant=self.frame.size.width/2;
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
    self.titleLabel1.text=self.category.name;
}

@end
