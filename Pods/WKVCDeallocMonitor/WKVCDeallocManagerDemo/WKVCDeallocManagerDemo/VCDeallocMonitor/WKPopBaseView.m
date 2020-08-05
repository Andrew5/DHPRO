//
//  WKPopBaseView.m
//  MKWeekly
//
//  Created by wangkun on 2017/8/2.
//  Copyright © 2017年 zymk. All rights reserved.
//

#import "WKPopBaseView.h"

@interface WKPopBaseView ()



@end

@implementation WKPopBaseView


#pragma mark 布局相关
- (void)setInterFace
{
    [super setInterFace];
    _contentView = [UIView new];
//    _contentView.dk_backgroundColorPicker = DKColorPickerWithKey(FFTo66);
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    self.priority = WKBaseViewShowPriorityNormal;

}








#pragma mark object methods

- (void)show:(BOOL)flag
{
    [self showInView:nil isShow:flag];
}


- (void)showAndAutoDismiss
{
    [self showAndAutoDismissAfterDelay:1];
}

- (void)showAndAutoDismissAfterDelay:(NSTimeInterval)second
{
    [self show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self show:NO];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
