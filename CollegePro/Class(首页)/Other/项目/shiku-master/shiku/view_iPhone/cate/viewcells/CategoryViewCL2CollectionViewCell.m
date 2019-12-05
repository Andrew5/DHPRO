//
//  CategoryViewCL2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CategoryViewCL2CollectionViewCell.h"

@implementation CategoryViewCL2CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.coverImageHeight.constant=self.frame.size.width;
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
