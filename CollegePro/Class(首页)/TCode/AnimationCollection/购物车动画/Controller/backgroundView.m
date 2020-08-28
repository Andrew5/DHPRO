//
//  backgroundView.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/23.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "backgroundView.h"
#import "AppDelegate.h"
@implementation backgroundView
//需外漏的方法
+ (instancetype)sureGuideView{
    return [[self alloc]initWith];
}
//初始化操作
- (instancetype)initWith{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
-(void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight);
    UIView *imageView = [[UIView alloc]init];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.frame = CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceWidth);
    imageView.userInteractionEnabled = YES;
    imageView.tag = 1000;
    [self addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
    [imageView addGestureRecognizer:tap];
    [self show];
}
- (void)touchImageView:(UITapGestureRecognizer*)tap {
    UIImageView *tapImageView = (UIImageView*)tap.view;
    //依次移除
    [tapImageView removeFromSuperview];
    if (tapImageView.tag - 1000 == 0) {
        //最后一张
        if (self.lastTapBlock) {
            self.lastTapBlock();
        }
        [self hide];
    }
}
//显示
- (void)show {
    [UIApplication sharedApplication].statusBarHidden = YES;
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDel.window addSubview:self];
}
//隐藏
- (void)hide {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
