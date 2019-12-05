//
//  GoodsDetailAvatarViewCell.m
//  shiku
//
//  Created by Brivio Wang on 15/7/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsDetailAvatarViewCell.h"

@implementation GoodsDetailAvatarViewCell
- (void)awakeFromNib {
    self.backgroundColor = WHITE_COLOR;
    self.coverImageView.layer.masksToBounds = YES;
    self.textLabel1.textColor = RGBCOLORV(0x666666);
    self.textLabel2.textColor = TEXT_COLOR_DARK;
    _bottomSplitView.backgroundColor = RGBCOLORV(0xf2f2f2);
}
@end
