//
//  UIViewController+YHMessageViewController.m
//  YHPopupViewDemo
//
//  Created by deng on 16/12/13.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "UIViewController+YHMessageViewController.h"
#import <objc/runtime.h>
#import "YHMessageView.h"

#define kYHMessageView @"kYHMessageView"
#define kYHTimer @"kYHTimer"
#define kYHMessageViewFrameY @"kYHMessageViewFrameY"

@interface UIViewController()

@property(nonatomic, retain) UIView *messageView;
@property(nonatomic, retain) NSTimer *timer;
@property(nonatomic, assign) NSNumber *messageViewFrameY;

@end

@implementation UIViewController (YHMessageViewController)

#pragma mark - inline property
- (UIView *)messageView {
    return objc_getAssociatedObject(self, kYHMessageView);
}

- (void)setMessageView:(UIView *)messageView {
    objc_setAssociatedObject(self, kYHMessageView, messageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)messageViewFrameY {
    return objc_getAssociatedObject(self, kYHMessageViewFrameY);
}

- (void)setMessageViewFrameY:(NSNumber *)messageViewFrameY {
    objc_setAssociatedObject(self, kYHMessageViewFrameY, messageViewFrameY, OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, kYHTimer);
}

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, kYHTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public method
- (void)presentMessageView:(UIView *)messageView {
    [self p_presentMessageView:messageView];
}

- (void)dismissMessageView {
    [self.timer invalidate];
    self.timer = nil;
    __weak UIView *view = self.messageView;
    [UIView animateWithDuration:1 animations:^{
        view.center = CGPointMake(self.messageView.center.x, -self.messageView.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    self.messageView = nil;
}


#pragma mark - private method
- (void)p_presentMessageView:(UIView *)messageView {
    [self.timer invalidate];
    self.timer = nil;
    
    self.messageViewFrameY = @(messageView.frame.origin.y);
    
    UIView *sourceView = [self topView];
    
    messageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [messageView addGestureRecognizer:panGestureRecognizer];
    
    if ([messageView isKindOfClass:[YHMessageView class]]) {
        YHMessageView *view = (YHMessageView *)messageView;
        if (view.showTime && view.showTime > 0) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:view.showTime//单位秒
                                             target:self
                                           selector:@selector(dismissMessageView)
                                           userInfo:nil
                                            repeats:YES ];
        }
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewEvent:)];
        tap.numberOfTapsRequired=1;
        [view addGestureRecognizer:tap];
    }
    CGRect originalFrame = messageView.frame;
    CGPoint originalCenter = messageView.center;
    messageView.center = CGPointMake(messageView.center.x, -originalFrame.size.height / 2);
    if (self.messageView) {
        messageView.center = CGPointMake(originalCenter.x, originalCenter.y);
        [self.messageView removeFromSuperview];
        self.messageView = messageView;
        [sourceView addSubview:self.messageView];
    } else {
        [sourceView addSubview:messageView];
        [UIImageView animateWithDuration:0.25 animations:^{
            messageView.center = CGPointMake(originalCenter.x, originalCenter.y);
        } completion:^(BOOL finished) {
            
        }];
        if (self.messageView) {
            [self.messageView removeFromSuperview];
            self.messageView = nil;
        }
        self.messageView = messageView;
    }
}


- (UIView *)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

#pragma mark - UIGestureRecognizerDelegate
- (void)tapViewEvent:(UITapGestureRecognizer *)recognizer {
    if ([recognizer.view isKindOfClass:[YHMessageView class]]) {
        YHMessageView *messageView = (YHMessageView *)recognizer.view;
        if (messageView.delegate && [messageView.delegate respondsToSelector:@selector(tapMessageView:)]) {
            [messageView.delegate tapMessageView:messageView];
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *) recognizer {
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    if (recognizer.view.frame.origin.y <= (CGFloat)self.messageViewFrameY.floatValue) {
        CGFloat offset = recognizer.view.center.y + velocity.y / 100;
        if (recognizer.view.frame.origin.y + velocity.y / 100 > (CGFloat)self.messageViewFrameY.floatValue) {
            recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x, (CGFloat)self.messageViewFrameY.floatValue, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
        } else {
            CGPoint center = CGPointMake(recognizer.view.center.x, offset);
            recognizer.view.center = center;
        }
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.view.frame.origin.y < self.messageViewFrameY.floatValue) {
            [UIView animateWithDuration:0.25 animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x, -self.messageView.frame.size.height);
            } completion:^(BOOL finished) {
            }];
        }
    }
}

@end
