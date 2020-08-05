//
//  WKBaseView.h
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKHeader.h"
//优先级 为后续队列拓展做准备工作
typedef enum : NSUInteger {
    WKBaseViewShowPriorityLow,
    WKBaseViewShowPriorityNormal,
    WKBaseViewShowPriorityHigh,
} WKBaseViewShowPriority;

@interface WKBaseView : UIView

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, assign) CGFloat animDuration;
@property (nonatomic, weak, readonly) UIView * parentView;
@property (nonatomic, assign) WKBaseViewShowPriority priority;

/**
 布局方法 子类 布局需复写  复写需先调用基类方法
 */
- (void)setInterFace;
/**
 执行出现和消失动画前会调用  若需要自定义动画 在此方法中设置改变后的动画属性对应值   动画时会自动调用
 
 @param isShow show or dismiss
 */
- (void)updateContentViewConstraint:(BOOL)isShow;//于此方法中调整布局 也达到消失动画 和 出现动画自定义

//展示方法 基本
- (void)dismiss;
- (void)showInView:(UIView *)view  isShow:(BOOL)flag;

//展示在view上  过time秒后 自动隐藏
- (void)showInView:(UIView *)view autoDismissAfterDelay:(NSTimeInterval)time;
//周期方法
- (void)viewWillShow;
- (void)viewDidShow;
- (void)viewWillDismiss;
- (void)viewDidDismiss;

@end
