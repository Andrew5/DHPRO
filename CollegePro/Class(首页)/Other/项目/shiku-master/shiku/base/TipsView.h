//
//  Tips.h
//   星空浩818
//
//  Created by  星空浩818 on 14/10/11.
//  Copyright (c) 2014年  星空浩818. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XZFramework/MBProgressHUD.h>

@interface TipsView : NSObject

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) MBProgressHUD *stringOnlyHud;

+ (TipsView *)sharedTipsView;

/**
 *  显示提示语
 *
 *  @param superView    它的父视图 nil时为window
 *  @param msg          提示语
 *  @param time         显示时间
 *  @param touchEnabled 是否可以交互
 *
 *  @return 返回实例 一般无需处理
 */
+ (MBProgressHUD*)showTipsWithSuperView:(UIView*)superView string:(NSString *)msg time:(NSTimeInterval)time touchEnabled:(BOOL)touchEnabled;

/**
 *  显示加载中
 *
 *  @param superView    它的父视图 nil时为window
 *  @param string       提示语
 *  @param touchEnabled 是否可以交互
 *
 *  @return 返回实例 一般无需处理
 */
+ (MBProgressHUD*)showLoadingViewWithSuperView:(UIView*)superView string:(NSString*)string touchEnabled:(BOOL)touchEnabled;

/**
 *  隐藏加载中视图
 */
+ (void)hideLoadingView;

+ (BOOL)isShowLoading;

@end
