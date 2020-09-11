//
//  DynamicStepProgressView.h
//  Test
//
//  Created by Rillakkuma on 2018/1/25.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicStepProgressView : UIView
/*
 *  frame:传入的CGRect决定了progressView的位置及大小
 *  targetNumber:传入时间节点数目(例:5)
 */
- (instancetype)initWithFrame:(CGRect)frame targetNumber:(NSInteger)targetNumber;

/*
 *  progress:当前进度 (传入整数例:4)
 */
- (void)setProgress:(CGFloat)progress;
@end
