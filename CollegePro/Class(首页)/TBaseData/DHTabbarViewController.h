//
//  DHTabbarViewController.h
//  CollegePro
//
//  Created by jabraknight on 2019/8/11.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "BaseViewController.h"

#define CTABBAR_BGIMG_NAME @"tabbar_bg.png"
#define CTABBAR_CELL_R 0.16
#define CTABBAR_CELL_G 0.23
#define CTABBAR_CELL_B 0.61
#define CTABBAR_CELL_A 1.0

#define CTABBAR_WIDTH DH_DeviceHeight
#define CTABBAR_HEIGHT 48
#define CTABBAR_TOP DH_DeviceHeight - 20 - CTABBAR_HEIGHT

NS_ASSUME_NONNULL_BEGIN

@class CTabViewCell;

@interface DHTabbarViewController : BaseViewController<UITabBarDelegate>
{
    NSUInteger selectedIndex;
@private
    UITabBar               *_tabBar;
    NSMutableArray         *_viewControllers;
    NSMutableArray         *_tabBarItems;
    UIViewController       *_selectedViewController;
    CTabViewCell           *_selectedCellBack;
}
@property(nonatomic) NSUInteger selectedIndex;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;
//使用方法  [[UIAppDelegate tab] hideTabBar:YES animated:YES];
- (void)activateViewControllerAt:(int)index;
- (void)hideTabBar:(BOOL)b animated:(BOOL)b2;
@end

NS_ASSUME_NONNULL_END
