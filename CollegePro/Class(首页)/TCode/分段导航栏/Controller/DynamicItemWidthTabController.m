//
//  DynamicItemWidthTabController.m
//  YPTabBarController
//
//  Created by 喻平 on 16/5/20.
//  Copyright © 2016年 YPTabBarController. All rights reserved.
//

#import "DynamicItemWidthTabController.h"
#import "SubparagraphViewController.h"

#import "BaseTabBarViewController.h"
@interface DynamicItemWidthTabController ()

@end

@implementation DynamicItemWidthTabController
- (void)buttonClicked:(UIButton *)sender{
//	[self.navigationController pushViewController:[[BaseTabBarViewController alloc] init] animated:YES];
//	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[UIApplication sharedApplication].keyWindow.rootViewController = [[BaseTabBarViewController alloc] init];

}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"返回原来控制器" forState:UIControlStateNormal];
	button.frame = CGRectMake(100, 100, 200, 50);
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:button];
	
	
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 20, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:22];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 15, 0, 15) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self initViewControllers];
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
    controller7.yp_tabItemTitle = @"第七个";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, controller6, controller7, nil];
}



@end
