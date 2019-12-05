//
//  HomeSection3CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeSection3CollectionViewCell.h"

@implementation HomeSection3CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=WHITE_COLOR;
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, aditem1)
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
    [self.coverImageView1 sd_setImageWithURL:url(self.aditem1.url) placeholderImage:img_placehold];
    
    [self.coverImageView2 sd_setImageWithURL:url(self.aditem2.url) placeholderImage:img_placehold];
    self.titleLabel1.text=self.aditem1.title;
    self.titleLabel2.text=self.aditem2.title;
    
}

@end
