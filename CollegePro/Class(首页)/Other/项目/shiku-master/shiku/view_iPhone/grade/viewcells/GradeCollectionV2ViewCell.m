//
//  CategoryViewCL2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GradeCollectionV2ViewCell.h"

@implementation GradeCollectionV2ViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.textColor=TEXT_COLOR_DARK;
//    self.coverImageHeight.constant=self.frame.size.width;
    CGFloat h=self.frame.size.width-31;
     self.coverViewHeight.constant=h;
    self.cimageViewHeight.constant=h-30;
    self.cimageViewWidth.constant=h-30;
    [self.coverView setHidden:YES];
    
    self.cimageView.layer.cornerRadius=20;
    self.cimageView.layer.masksToBounds=YES;
    self.cCoverImageView.layer.cornerRadius=20;
    self.cCoverImageView.layer.masksToBounds=YES;
    
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
    [self.coverView setHidden:YES];
     [self.cimageView sd_setImageWithURL:[NSURL URLWithString:self.category.img.small] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text=self.category.name;
}
@end
