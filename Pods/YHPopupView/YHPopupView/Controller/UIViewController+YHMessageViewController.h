//
//  UIViewController+YHMessageViewController.h
//  YHPopupViewDemo
//
//  Created by deng on 16/12/13.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YHMessageViewController)

@property (nonatomic, retain, readonly) UIView *messageView;

- (void)presentMessageView:(UIView *)messageView;

- (void)dismissMessageView;

@end
