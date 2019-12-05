//
//  CategoryViewCL2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GradeCollectionViewCell.h"

@implementation GradeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.textColor=TEXT_COLOR_DARK;
    self.coverImageHeight.constant=self.frame.size.width;
     self.coverViewHeight.constant=self.frame.size.width;
    [self.coverView setHidden:YES];
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
     [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.category.img.small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text=self.category.name;
}
@end
