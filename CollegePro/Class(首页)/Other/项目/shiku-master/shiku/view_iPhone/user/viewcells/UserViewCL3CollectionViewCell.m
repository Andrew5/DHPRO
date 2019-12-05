//
//  UserViewCL3CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserViewCL3CollectionViewCell.h"

@implementation UserViewCL3CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.coverImage.layer.cornerRadius=self.coverImage.frame.size.width/3;
//    self.coverImage.layer.masksToBounds =YES;
//    [self.coverImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    [self.coverImage setContentScaleFactor:self.bounds.size.width];
//    [self.coverImage setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    self.coverImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
//    self.coverImage.clipsToBounds = YES;
    self.label1.textColor=TEXT_COLOR_BLACK;
}

@end
