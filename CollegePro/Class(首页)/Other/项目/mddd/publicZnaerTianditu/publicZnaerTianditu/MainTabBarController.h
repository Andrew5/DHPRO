//
//  MainTabBarController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MainTabBarController : UITabBarController

@property(nonatomic,strong)AppDelegate *appDelegate;

-(void)hideTabBar;
-(void)showTabBar;
-(void)backFirstVC;
@end
