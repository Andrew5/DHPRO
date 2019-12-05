//
//  HCWProgressHUD.h
//  Example
//
//  Created by BOOU on 2017/3/2.
//  Copyright © 2017年 HCW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HCWProgressHUDMode) {
    HCWProgressHUDModeLoading,      ///< 加载中
    HCWProgressHUDModeNoInternet,   ///< 没有网络
    HCWProgressHUDModeNoData,       ///< 没有数据
    HCWProgressHUDModeCustom,       ///< 自定义错误
};

#ifndef HCW_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define HCW_INSTANCETYPE instancetype
#else
#define HCW_INSTANCETYPE id
#endif
#endif

typedef void (^HCWProgressHUDTapContentBlock)(HCWProgressHUDMode mode);    ///< 点击内容回调
typedef void (^HCWProgressHUDClickButtonBlock)(HCWProgressHUDMode mode);   ///< 点击按钮回调

@interface HCWProgressHUD : UIView

#pragma mark - Class Methods

/**
 *  创建一个HUD在指定的view上显示
 *  @param view HUD将添加到这个view上
 *  @param animated 是否需要动画
 */
+ (HCW_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

/**
 *  创建一个HUD在指定的view上显示
 *  @param view HUD将添加到这个view上
 *  @param animated 是否需要动画
 *  @param tapContentBlock 点击内容回调
 *  @param clickButtonBlock 点击按钮回调
 */
+ (HCW_INSTANCETYPE)showHUDAddedTo:(UIView *)view
                          animated:(BOOL)animated
                   tapContentBlock:(HCWProgressHUDTapContentBlock)tapContentBlock
                  clickButtonBlock:(HCWProgressHUDClickButtonBlock)clickButtonBlock;

/**
 *  在指定的view上隐藏一个HUD
 *  @param view HUD添加到的view
 *  @param animated 是否需要动画
 */
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;

/**
 *  在指定的view上获取HUD
 *  @param view HUD添加到的view
 */
+ (HCW_INSTANCETYPE)HUDForView:(UIView *)view;

#pragma mark - Object Methods

/**
 *  初始化HUD在window上
 *  @param window HUD添加到的window
 */
- (id)initWithWindow:(UIWindow *)window;

/**
 *  初始化HUD在view上
 *  @param view HUD添加到的view
 */
- (id)initWithView:(UIView *)view;

/**
 *  显示HUD
 *  @param animated 动画
 */
- (void)show:(BOOL)animated;

/**
 *  隐藏HUD
 *  @param animated 动画
 */
- (void)hide:(BOOL)animated;

#pragma mark - Object Propertys

@property (copy) HCWProgressHUDTapContentBlock tapContentBlock;     ///< 点击内容回调block
@property (copy) HCWProgressHUDClickButtonBlock clickButtonBlock;   ///< 点击按钮回调block
@property (assign) HCWProgressHUDMode mode;                         ///< HUD状态

@property (strong) UIColor *textCorlor;
@property (strong) UIColor *buttonCorlor;

// loading
@property (strong) UIColor  *indicatorCorlor;
@property (strong) NSString *loadingText;

// noInternet
@property (strong) UIImage  *noInternetImage;
@property (strong) NSString *noInternetText;
@property (strong) NSString *noInternetButtonText;

// noData
@property (strong) UIImage  *noDataImage;
@property (strong) NSString *noDataText;
@property (strong) NSString *noDataButtonText;

// custom
@property (strong) UIImage  *customImage;
@property (strong) NSString *customText;
@property (strong) NSString *customButtonText;

@end
