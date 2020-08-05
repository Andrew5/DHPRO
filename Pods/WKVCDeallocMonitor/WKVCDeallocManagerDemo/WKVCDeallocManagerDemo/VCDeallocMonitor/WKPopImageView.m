//
//  WKPopImageView.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKPopImageView.h"

@interface WKPopImageView ()

@property (nonatomic, strong) UIImageView * thisIV;

@end

@implementation WKPopImageView


- (void)setInterFace
{
    [super setInterFace];
    
    self.contentView.frame = CGRectMake(20, 20, WK_SCREEN_WIDTH - 40, WK_SCREEN_HEIGHT - 40);
    self.thisIV = [UIImageView new];
    [self.contentView addSubview:self.thisIV];
    self.thisIV.frame = self.contentView.bounds;
    self.thisIV.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.thisIV addGestureRecognizer:tap];
    
}

- (void)setImg:(UIImage *)img
{
    _img = img;
    self.thisIV.image = img;
}

/*

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
