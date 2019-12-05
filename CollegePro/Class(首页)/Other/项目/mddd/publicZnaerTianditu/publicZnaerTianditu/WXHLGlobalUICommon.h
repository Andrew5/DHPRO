//
//  WXHLGlobalUICommon.h
//  WXMovie
//
//  Created by xiongbiao on 12-12-11.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>

#define WXHL_ROW_HEIGHT                 WXHLkDefaultRowHeight
#define WXHL_TOOLBAR_HEIGHT             WXHLkDefaultPortraitToolbarHeight
#define WXHL_LANDSCAPE_TOOLBAR_HEIGHT   WXHLkDefaultLandscapeToolbarHeight

#define WXHL_KEYBOARD_HEIGHT                 WXHLkDefaultPortraitKeyboardHeight
#define WXHL_LANDSCAPE_KEYBOARD_HEIGHT       WXHLkDefaultLandscapeKeyboardHeight
#define WXHL_IPAD_KEYBOARD_HEIGHT            WXHLkDefaultPadPortraitKeyboardHeight
#define WXHL_IPAD_LANDSCAPE_KEYBOARD_HEIGHT  WXHLkDefaultPadLandscapeKeyboardHeight

#define  OFFSET 20  //新闻图集的偏移位置

//安全释放对象
#define RELEASE_SAFELY(__POINTER) { if(__POINTER){[__POINTER release]; __POINTER = nil; }}

/**
 * @返回当前iPhone OS 运行的版本
 */
float WXHLOSVersion();

/**
 * 
 */
BOOL WXHLOSVersionIsAtLeast(float version);

/**
 * @返回YES 键盘是可视化的
 */
BOOL WXHLIsKeyboardVisible();

/**
 * @返回YES，设备支持iPhone
 */
BOOL WXHLIsPhoneSupported();

/**
 * @返回YES，设备是iPad
 */
BOOL WXHLIsPad();

/**
 * @返回当前设备方向
 */
UIDeviceOrientation WXHLDeviceOrientation();

/**
 * 在iPhone/iPad touch上
 * 检查如果屏幕是portrait, landscape left, or landscape right.
 * 这个方法帮你忽略home按钮朝上的方向
 *
 * 在iPad上，一直返回YES
 */
BOOL WXHLIsSupportedOrientation(UIInterfaceOrientation orientation);

/**
 * @指定方法返回旋转的transform
 */
CGAffineTransform WXHLRotateTransformForOrientation(UIInterfaceOrientation orientation);

/**
 * @返回应用程序物理屏幕大小
 *
 */
CGRect WXHLApplicationBounds();
/**
 * @返回应用程序去掉状态栏高度的大小
 *
 */
CGRect WXHLApplicationFrame();

/**
 * @返回指定方向toolBar的高度
 *
 */
CGFloat WXHLToolbarHeightForOrientation(UIInterfaceOrientation orientation);

/**
 * @ 返回指定方向的键盘的高度
 */
CGFloat WXHLKeyboardHeightForOrientation(UIInterfaceOrientation orientation);

/**
 * @ 返回分组表格视图cell与屏幕之间的间距，iPad的间距会更大
 */
CGFloat WXHLGroupedTableCellInset();

///////////////////////////////////////////////////////////////////////////////////////////////////
// Dimensions of common iPhone OS Views

/**
 * 标准的tableview行高
 * @const 44 pixels
 */
extern const CGFloat WXHLkDefaultRowHeight;

/**
 * 标准的toolBar竖屏的高度The standard height of a toolbar in portrait orientation.
 * @const 44 pixels
 */
extern const CGFloat WXHLkDefaultPortraitToolbarHeight;

/**
 * 标准的toolBar横屏的高度 
 * @const 33 pixels
 */
extern const CGFloat WXHLkDefaultLandscapeToolbarHeight;

/**
 * 标准的键盘竖屏的高度
 * @const 216 pixels
 */
extern const CGFloat WXHLkDefaultPortraitKeyboardHeight;

/**
 * 标准的键盘横屏的高度
 * @const 160 pixels
 */
extern const CGFloat WXHLkDefaultLandscapeKeyboardHeight;

/**
 * 分组的表格视图cell边界与屏幕的间距
 * @const 10 pixels
 */
extern const CGFloat WXHLkGroupedTableCellInset;
