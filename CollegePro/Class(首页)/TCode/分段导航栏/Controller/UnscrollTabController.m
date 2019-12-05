//
//  UnscrollTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 16/5/25.
//  Copyright © 2016年 YPTabBarController. All rights reserved.
//

#import "UnscrollTabController.h"
#import "SubparagraphViewController.h"

@interface UnscrollTabController ()

@end

@implementation UnscrollTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewControllers];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 20, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.backgroundColor = [UIColor grayColor];
    
    self.tabBar.itemTitleColor = [UIColor redColor];
    self.tabBar.itemTitleSelectedColor = [UIColor whiteColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:18];
    
//    移动条效果
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemColorChangeFollowContentScroll = YES;
    
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsZero tapSwitchAnimated:YES];
//    界面的移动效果
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    [self.yp_tabItem setDoubleTapHandler:^{
        NSLog(@"双击效果");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewControllers {
    SubparagraphViewController *controller1 = [[SubparagraphViewController alloc] init];
    controller1.yp_tabItemTitle = @"第一";
    
    SubparagraphViewController *controller2 = [[SubparagraphViewController alloc] init];
    controller2.yp_tabItemTitle = @"第二";
    
    SubparagraphViewController *controller3 = [[SubparagraphViewController alloc] init];
    controller3.yp_tabItemTitle = @"第三";
    
    SubparagraphViewController *controller4 = [[SubparagraphViewController alloc] init];
    controller4.yp_tabItemTitle = @"第四";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
    
}

@end
