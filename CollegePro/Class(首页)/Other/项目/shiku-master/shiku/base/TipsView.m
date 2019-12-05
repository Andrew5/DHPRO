//
//  Tips.m
//   星空浩818
//
//  Created by  星空浩818 on 14/10/11.
//  Copyright (c) 2014年  星空浩818. All rights reserved.
//

#import "TipsView.h"
#import "AppDelegate.h"

#define DefaultString @"加载中，请稍等..."

@interface TipsView ()<MBProgressHUDDelegate>

@end

@implementation TipsView

static TipsView *_sharedTipsView = nil;

+ (TipsView *)sharedTipsView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTipsView = [[TipsView alloc] init];
    });
    
    return _sharedTipsView;
}

+ (MBProgressHUD*)showTipsWithSuperView:(UIView *)superView string:(NSString *)msg time:(NSTimeInterval)time touchEnabled:(BOOL)touchEnabled
{
    return [[self sharedTipsView] showTipsWithSuperView:superView string:msg time:time touchEnabled:touchEnabled];
}

+ (MBProgressHUD*)showLoadingViewWithSuperView:(UIView *)superView string:(NSString *)string touchEnabled:(BOOL)touchEnabled
{
    return [[self sharedTipsView] showLoadingViewWithSuperView:superView string:string touchEnabled:touchEnabled];
}

- (MBProgressHUD*)showTipsWithSuperView:(UIView *)superView string:(NSString *)msg time:(NSTimeInterval)time touchEnabled:(BOOL)touchEnabled
{
    [_stringOnlyHud removeFromSuperview];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!superView) {
        superView = delegate.window.viewForBaselineLayout;
    }
    
    _stringOnlyHud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
    _stringOnlyHud.mode = MBProgressHUDModeText;
    _stringOnlyHud.margin = 10.f;
    //_stringOnlyHud.yOffset = 120.f;
    _stringOnlyHud.removeFromSuperViewOnHide = YES;
    _stringOnlyHud.delegate = self;
    _stringOnlyHud.userInteractionEnabled = !touchEnabled;
    _stringOnlyHud.labelText = msg;
    
    [_stringOnlyHud hide:YES afterDelay:time];
    return _stringOnlyHud;
}

//显示loadingView
- (MBProgressHUD*)showLoadingViewWithSuperView:(UIView *)superView string:(NSString *)string touchEnabled:(BOOL)touchEnabled
{
    
    [_hud removeFromSuperview];
    
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!superView) {
        superView = delegate.window.viewForBaselineLayout;
    }
    
    _hud = [[MBProgressHUD alloc] initWithView:superView];
    _hud.userInteractionEnabled = !touchEnabled;
    _hud.delegate  = self;
    //_hud.yOffset = 90.f;
    _hud.margin = 10.f;
    _hud.labelText = string.length?string:DefaultString;
    [superView addSubview:_hud];
    [_hud show:YES];
    
    return _hud;
    
}

+ (void)hideLoadingView
{
    [[self sharedTipsView].hud hide:YES];
}

//loadingView隐藏 代理
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [hud removeFromSuperview];
    hud = nil;

}

+ (BOOL)isShowLoading
{
    return [self sharedTipsView].hud.superview != nil;
}

@end
