//
//  YHPopupViewAnimation.h
//  YHPopupView
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+YHPopupViewController.h"

@interface YHPopupViewAnimation : UIView<YHPopupAnimation>

- (id)initWithPopupStartRect:(CGRect)popupStartRect
       popupEndRect:(CGRect)popupEndRect
     dismissEndRect:(CGRect)dismissEndRect;

@end
