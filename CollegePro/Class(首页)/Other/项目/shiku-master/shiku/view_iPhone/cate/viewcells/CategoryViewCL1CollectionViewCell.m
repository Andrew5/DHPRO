//
//  CategoryViewCL1CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CategoryViewCL1CollectionViewCell.h"

@implementation CategoryViewCL1CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
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
    self.nameLabel.text=self.category.name;
}

@end
