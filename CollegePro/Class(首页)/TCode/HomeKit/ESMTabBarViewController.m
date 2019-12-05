//
//  ESMTabBarViewController.m
//  HomeKit
//
//  Created by 可米小子 on 16/10/27.
//  Copyright © 2016年 可米小子. All rights reserved.
//

#import "ESMTabBarViewController.h"
#import "ESMNavigationViewController.h"

@interface ESMTabBarViewController ()

@end

@implementation ESMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVCs];
}

- (void)addChildVCs {
    NSAssert(NO, @"Should not call this method");
}

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    ESMNavigationViewController *nav = [[ESMNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    childVc.title = title;
    UIImage *image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0){
        //声明这张图用原图
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    childVc.tabBarItem.title = title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
