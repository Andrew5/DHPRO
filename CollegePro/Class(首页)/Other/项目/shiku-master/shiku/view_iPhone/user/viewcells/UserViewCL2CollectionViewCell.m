//
//  UserViewCL2CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserViewCL2CollectionViewCell.h"

@implementation UserViewCL2CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.label1.textColor=TEXT_COLOR_DARK;
    self.iconLabel.textColor=WHITE_COLOR;
//    self.iconLabel.backgroundColor=WHITE_COLOR;
    self.iconLabel.layer.cornerRadius=self.iconLabel.frame.size.width/2;
    self.iconLabel.layer.masksToBounds=YES;
}

@end
