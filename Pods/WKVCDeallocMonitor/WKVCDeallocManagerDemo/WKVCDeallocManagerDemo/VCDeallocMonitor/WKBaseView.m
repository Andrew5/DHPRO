//
//  WKBaseView.m
//  KanManHua
//
//  Created by wangkun on 2017/11/8.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "WKBaseView.h"

#define NightViewTag 9999

@interface WKBaseView ()

@property (nonatomic, weak) UIView * parentView;
@property (nonatomic, assign) NSTimeInterval autoDissmissDelay;

@end
@implementation WKBaseView


- (void)setInterFace
{
    _bgView = [[UIView alloc] init];
    [self addSubview:_bgView];
    
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.bgView addGestureRecognizer:tap];
    _bgView.userInteractionEnabled = YES;
    self.userInteractionEnabled= YES;
    self.priority = WKBaseViewShowPriorityLow;
    self.alpha = 0;
}

#pragma mark 动画相关

- (void)showInView:(UIView *)view  isShow:(BOOL)flag
{
    UIView * keyView = [UIApplication sharedApplication].keyWindow;
    if (!view) {
        view = keyView;
    }
    else
    {
        //判断传入view在keywindow上是否有宽高，没有则使用keywindow作为superview
        CGRect frame = [view convertRect:view.frame toView:keyView];
        if (frame.size.width == 0 || frame.size.height == 0) {
            view = keyView;
        }
    }
    self.parentView = view;
    if (flag) {

        [self queueShow:YES];
    }
    else
    {
        [self queueShow:NO];
    }
}

- (void)dismiss{
    [self queueShow:NO];
}

//抽离类 方便队列
- (void)queueShow:(BOOL)flag
{

    if (flag) {
        if (!self.parentView) {
            return;
        }

        [self.parentView addSubview:self];
        self.frame = self.parentView.bounds;
        self.bgView.frame = self.bounds;
        [self viewWillShow];
        if (self.autoDissmissDelay > 0) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:self.autoDissmissDelay];
        }
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [self viewWillDismiss];
    }
    
    CGFloat alpha = flag;
    [self layoutIfNeeded];
    [UIView animateWithDuration:self.animDuration animations:^{
        [self updateContentViewConstraint:flag];
        self.alpha = alpha;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            if (!flag) {
                [self viewDidDismiss];
                [self removeFromSuperview];
            }
            else
            {
                [self viewDidShow];
                //保证自己在view最上层
                [self.superview bringSubviewToFront:self];

            }
        }
    }];
}

- (void)showInView:(UIView *)view autoDismissAfterDelay:(NSTimeInterval)time
{
    self.autoDissmissDelay = time;
    [self showInView:view isShow:YES];
}

#pragma mark 父类方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        _animDuration = 0.25;
        _autoDissmissDelay = -1;
        [self setInterFace];
    }
    return self;
}

#pragma 子类继承实现

- (void)updateContentViewConstraint:(BOOL)isShow{}
- (void)viewWillShow{}
- (void)viewDidShow{}
- (void)viewWillDismiss{}
- (void)viewDidDismiss{}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
