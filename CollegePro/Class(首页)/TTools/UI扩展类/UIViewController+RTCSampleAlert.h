//
//  UIViewController+RTCSampleAlert.h
//  RtcSample
//
//  Created by daijian on 2019/2/28.
//  Copyright © 2019年 tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RTCSampleAlert)

+ (id)getRootController;

/**
 *  回到主界面
 *
 *  @param view 当前显示的试图
 *  @param vc 当前显示的试图
 */
+ (void)backToHostController:(UIView *)view viewController:(UIViewController *)vc;

/**
 *  回到主界面
 *
 *  @param view 当前显示的试图
 */
+ (void)backToHostController:(UIView *)view;

/**
 获取最顶层控制器

 @param rootViewController //一般传[UIApplication sharedApplication].keyWindow.rootViewController
 @return 最顶层控制器
 */
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

+ (UIViewController*) topMostController;

/**
 @brief 提示框提醒

 @param message 提示信息
 */
- (void)showAlertWithMessage:(NSString *)message handler:(void (^)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
