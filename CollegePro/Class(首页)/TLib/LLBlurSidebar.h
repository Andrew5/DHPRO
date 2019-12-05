//
//  LLBlurSidebar.h
//  Gaoguan
//
//  Created by lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSidebarWidth
#define kSidebarWidth 160.0 // 侧栏宽度，设屏宽为320，右侧留一条空白可以看到背后页面内容
#endif

@interface LLBlurSidebar : BaseViewController

@property (nonatomic, retain) UIView* contentView; // 所有要显示的子控件全添加到这里
@property (nonatomic, assign) BOOL isSidebarShown;

/**
 * @brief 设置侧栏的背景色，参数为16进制0xffffff的形式
 */
- (void)setBgRGB:(long)rgb;

/**
 * @brief 当有pan事件时调用，传入UIPanGestureRecognizer，仅供右滑返回手势使用
 */
- (void)panDetectedForBack:(UIPanGestureRecognizer *)recoginzer;

/**
 * @brief 当有pan事件时调用，传入UIPanGestureRecognizer
 */
- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;

/**
 * @brief 执行显示/隐藏Sidebar
 */
- (void)showHideSidebar;

/**
 * @brief 已经完成显示，需要时可以在子类中用
 */
- (void)sidebarDidShown;

/**
 * @brief 触发了右滑事件，需要时可以在子类中用
 */
- (void)slideToRightOccured;


@end
