//
//  FixedItemWidthTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 16/5/13.
//  Copyright © 2016年 YPTabBarController. All rights reserved.
//

#import "FixedItemWidthTabController.h"
#import "SubparagraphViewController.h"
@interface FixedItemWidthTabController ()

@end

@implementation FixedItemWidthTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewControllers];
    
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 20, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64 - 50)];

    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:22];

    [self.tabBar setScrollEnabledAndItemWidth:80];
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 10, 0, 10) tapSwitchAnimated:NO];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self.yp_tabItem setDoubleTapHandler:^{
        NSLog(@"双击效果");
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initViewControllers {
    SubparagraphViewController *controller1 = [[SubparagraphViewController alloc] init];
    controller1.yp_tabItemTitle = @"第一个";
    
    
    SubparagraphViewController *controller2 = [[SubparagraphViewController alloc] init];
    controller2.yp_tabItemTitle = @"第二";
    
    SubparagraphViewController *controller3 = [[SubparagraphViewController alloc] init];
    controller3.yp_tabItemTitle = @"第三个";
    
    SubparagraphViewController *controller4 = [[SubparagraphViewController alloc] init];
    controller4.yp_tabItemTitle = @"第四";
    
    SubparagraphViewController *controller5 = [[SubparagraphViewController alloc] init];
    controller5.yp_tabItemTitle = @"第五个";
    
    SubparagraphViewController *controller6 = [[SubparagraphViewController alloc] init];
    controller6.yp_tabItemTitle = @"第六";
    
    SubparagraphViewController *controller7 = [[SubparagraphViewController alloc] init];
    controller7.yp_tabItemTitle = @"第七";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6, controller7, nil];
    
}

@end
