//
//  UserViewCL1CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserViewCL1CollectionViewCell.h"

@implementation UserViewCL1CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.speratorline.backgroundColor=BG_COLOR;
    
    self.label2.textColor=TEXT_COLOR_DARK;
    self.label1.layer.cornerRadius = 7.5;
    self.label1.layer.masksToBounds = YES;
}

@end
