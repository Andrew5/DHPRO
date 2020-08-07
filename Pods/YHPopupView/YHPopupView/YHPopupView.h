//
//  YHPopupView.h
//  YHPopupView
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPopupViewAnimation.h"
#import "UIViewController+YHPopupViewController.h"

@interface YHPopupView : UIView

@property(nonatomic, assign) BOOL clickBlankSpaceDismiss;
@property(nonatomic, strong) UIColor *backgroundViewColor;

- (instancetype)initWithFrame:(CGRect)frame;

@end
