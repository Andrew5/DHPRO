//
//  ESMNavigationViewController.h
//  HomeKit
//
//  Created by 可米小子 on 16/10/27.
//  Copyright © 2016年 可米小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESMNavigationViewController : UINavigationController

@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end
