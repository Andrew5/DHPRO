//
//  ESMTabBarVC.m
//  HomeKit
//
//  Created by 可米小子 on 16/10/27.
//  Copyright © 2016年 可米小子. All rights reserved.
//

#import "ESMTabBarVC.h"
#import "ESMHomeViewController.h"
#import "ESMTestViewController.h"
#import "ESMMoneyViewController.h"
#import "ESMMeViewController.h"

#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface ESMTabBarVC ()

@end

@implementation ESMTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"tabBar_bg"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    imageView.image = image;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tabBar insertSubview:imageView atIndex:1];
}

-(void)addChildVCs {
    ESMHomeViewController *homeVC = [[ESMHomeViewController alloc]init];
    [self addOneChildVc:homeVC title:@"首页" imageName:@"tabBar_home_normal" selectedImageName:@"tabBar_home_press"];
    
    ESMTestViewController *recomVc = [[ESMTestViewController alloc]init];
    [self addOneChildVc:recomVc title:@"测试" imageName:@"tabBar_category_normal" selectedImageName:@"tabBar_category_press"];
    ESMMoneyViewController *wealthVc = [[ESMMoneyViewController alloc]init] ;
    [self addOneChildVc:wealthVc title:@"钞票" imageName:@"tabBar_wealth_normal" selectedImageName:@"tabBar_wealth_press"];
    ESMMeViewController *meVc = [[ESMMeViewController alloc]init] ;
    [self addOneChildVc:meVc title:@"我" imageName:@"tabBar_me_normal" selectedImageName:@"tabBar_me_press"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UITabBarItem *apperrance = [UITabBarItem appearance];
        [apperrance setTitleTextAttributes:@{NSForegroundColorAttributeName:kRGBA(251, 74, 74, 1)} forState:UIControlStateSelected];
        [apperrance setTitleTextAttributes:@{NSForegroundColorAttributeName : kRGBA(133, 133, 133, 1)} forState:UIControlStateNormal];
    }
    return self;
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
