//
//  XFAssetsLibraryAccessFailureView.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsLibraryAccessFailureView.h"

@implementation XFAssetsLibraryAccessFailureView

+ (instancetype)makeView {
    return loadSelfXib;
}

- (void)awakeFromNib {
    
}

- (void)show {
    self.frame = CGRectMake(0.f, XFScreenHeight, XFScreenWidth, XFScreenHeight);
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.frame = CGRectMake(0.f, 0.f, XFScreenWidth, XFScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)didCancelButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.35f animations:^{
        self.frame = CGRectMake(0.f, XFScreenHeight, XFScreenWidth, XFScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)didPushPrivilegeButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


@end
