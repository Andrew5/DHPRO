//
//  UIView+RandomCorner.h
//  RandomCornerDemo
//
//  Created by zzg on 2018/5/9.
//  Copyright © 2018年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RandomCorner)


/**
 给view设置圆角

 @param corners 圆角位置
 @param cornerRadii 圆角弧度
 */
- (void)setCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end
