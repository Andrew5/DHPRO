//
//  BaseViewController.h
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 是否显示返回按钮
 */
@property(nonatomic,assign) BOOL isShowleftBtn;

- (void)dh_setupUI;
#pragma mark - ***** 网络类型判断
/**设置返回按钮
 */
- (void)dh_setBackItem;
/**push隐藏tabbar
 */
- (void)dh_hideBottomBarPush:(BaseViewController *)controller;

/*!
 *  使用4G网络时的方法调用此方法
 */
- (void)dh_netUse4Gnet;

#pragma mark - ***** VC的基本设置
/*!
 *  设置VC的背景颜色
 *
 *  @param vcBgColor vcBgColor
 */
//- (void)setVCBgColor:(UIColor *)vcBgColor;


#pragma mark - ***** VC的navi设置
/*!
 *  设置navi
 */
- (void)dh_setupNavi;
/*!
 *  是否隐藏naviBar
 *
 *  @param hidden YES：隐藏，NO：显示
 */
- (void)dh_setNavbarBackgroundHidden:(BOOL)hidden;

-(UIBarButtonItem *)dh_tbarBackButtonWhiteAndPopView;
-(UIBarButtonItem *)dh_tBarIconButtonItemWithImage:(NSString *)text action:(SEL)selctor;
-(UIBarButtonItem *)dh_tBarIconButtonItem:(NSString *)text action:(SEL)selctor;

- (void)closeCurruntPage;
@end
