//
//  ESMTabBarViewController.h
//  HomeKit
//
//  Created by 可米小子 on 16/10/27.
//  Copyright © 2016年 可米小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESMTabBarViewController : UITabBarController

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

- (void)addChildVCs;

@end
