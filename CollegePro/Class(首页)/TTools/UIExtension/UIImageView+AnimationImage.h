//
//  UIImageView+AnimationImage.h
//  PresentTest
//
//  Created by Raymond~ on 2016/10/9.
//  Copyright © 2016年 Raymond~. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VoidBlock)();


@interface UIImageView (AnimationImage)

- (BOOL)FR_isAnimating;
/**
 开始动画
 */
- (void)FR_startAnimating;

/**
 结束动画
 */
- (void)FR_stopAnimating;
/**
 初始化帧动画

 @param imageNames        帧动画需要的图片名字数组
 @param animationDuration 一次动画需要的时间
 @param repeatCount       重复次数 0为循环
 @param doneBlock         动画完成回调（stop也会触发）
 */
- (void)animationImageNames:(NSArray *)imageNames
          animationDuration:(NSTimeInterval)animationDuration
                repeatCount:(NSInteger)repeatCount
                  doneBlock:(VoidBlock)doneBlock;

@end
