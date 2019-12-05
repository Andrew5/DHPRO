//
//  SFProgressHUD.m
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/11.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import "SFProgressHUD.h"

@implementation SFProgressHUD
+(instancetype)shareinstance{
    
    static SFProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SFProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(SFProgressMode *)myMode{
    //如果已有弹框，先消失
    if ([SFProgressHUD shareinstance].hud != nil) {
        [[SFProgressHUD shareinstance].hud hideAnimated:YES];
        [SFProgressHUD shareinstance].hud = nil;
    }
    
    //4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [SFProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //[SFProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
    //[SFProgressHUD shareinstance].hud.color = [UIColor blackColor];
    [SFProgressHUD shareinstance].hud.bezelView.color = [UIColor blackColor];
    [[SFProgressHUD shareinstance].hud setMargin:10];
    [[SFProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    [SFProgressHUD shareinstance].hud.detailsLabel.text = msg;
    [SFProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    [SFProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    switch ((NSInteger)myMode) {
        case SFProgressModeOnlyText:
            [SFProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            break;
            
        case SFProgressModeLoading:
            [SFProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
        case SFProgressModeCircleLoading:
            [SFProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
            break;
            
        case SFProgressModeSuccess:
            [SFProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [SFProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
            break;
            
        default:
            break;
    }
    
    
    
}


+(void)hide{
    if ([SFProgressHUD shareinstance].hud != nil) {
        [[SFProgressHUD shareinstance].hud hideAnimated:YES];
    }
}


+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeOnlyText];
    [[SFProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
}


+(void)showOnlyText:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeOnlyText];
}

+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeOnlyText];
    [[SFProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeSuccess];
    [[SFProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeLoading];
}

+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:(SFProgressMode *)SFProgressModeOnlyText];
    [[SFProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

@end

