//
//  HomeSection2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeSection2CollectionViewCell.h"

@implementation HomeSection2CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.coverImage.layer.cornerRadius=self.coverImage.frame.size.width/2;
    self.coverImage.layer.masksToBounds =YES;
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, adItem)
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
    [self.coverImage sd_setImageWithURL:url(self.adItem.url) placeholderImage:img_placehold];
    self.titleLabel1.text=self.adItem.title;
}

@end
