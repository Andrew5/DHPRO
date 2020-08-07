//
//  UIViewController+YYPopupViewController.m
//  YYPopupView
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "UIViewController+YHPopupViewController.h"
#import <objc/runtime.h>
#import "YHPopupView.h"

#define kYHPopupView @"kYHPopupView"
#define kYHOverlayView @"kYHOverlayView"
#define kYHPopupAnimation @"kYHPopupAnimation"
#define BackgoundViewTag 930527

@interface UIViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, retain) UIView *popupView;
@property(nonatomic, retain) UIView *overlayView;
@property(nonatomic, retain) id<YHPopupAnimation> popupAnimation;

@end

@implementation UIViewController (YYPopupViewController)


#pragma mark - inline property
- (UIView *)popupView {
    return objc_getAssociatedObject(self, kYHPopupView);
}

- (void)setPopupView:(UIView *)popupView {
    objc_setAssociatedObject(self, kYHPopupView, popupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlayView{
    return objc_getAssociatedObject(self, kYHOverlayView);
}

- (void)setOverlayView:(UIView *)overlayView {
    objc_setAssociatedObject(self, kYHOverlayView, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<YHPopupAnimation>)popupAnimation{
    return objc_getAssociatedObject(self, kYHPopupAnimation);
}

- (void)setPopupAnimation:(id<YHPopupAnimation>)popupAnimation{
    objc_setAssociatedObject(self, kYHPopupAnimation, popupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public method
- (void)presentPopupView:(UIView *)popupView {
    [self p_presentPopupView:popupView];
}

- (void)presentPopupView:(UIView *)popupView animation:(id<YHPopupAnimation>)animation {
    self.popupAnimation = animation;
    [self p_presentPopupView:popupView];
    if (animation) {
        [animation showView:popupView overlayView:self.overlayView];
    }
}

- (void)dismissPopupView {
    [self.overlayView removeFromSuperview];
    [self.popupView removeFromSuperview];
    self.overlayView = nil;
    self.popupView = nil;
    self.popupAnimation = nil;
}

- (void)dismissPopupViewWithAnimation:(id<YHPopupAnimation>)animation {
    if (animation) {
        __weak __typeof(&*self)weakSelf = self;
        [animation dismissView:self.popupView overlayView:self.overlayView completion:^(void) {
            [weakSelf dismissPopupView];
        }];
    }else{
        [self dismissPopupView];
    }
}

#pragma mark - private method
- (void)p_dismissPopupView{
    [self dismissPopupViewWithAnimation:self.popupAnimation];
}

- (void)p_presentPopupView:(UIView *)popupView {
    if ([self.overlayView.subviews containsObject:popupView]) {
        return;
    }
    self.popupView = nil;
    self.popupView = popupView;
    self.popupAnimation = nil;
    
    UIView *sourceView = [self topView];
    
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if (!self.overlayView) {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        backgroundView.tag = BackgoundViewTag;
        [overlayView addSubview:backgroundView];
        
        if ([popupView isKindOfClass:[YHPopupView class]]) {
            YHPopupView *pv = (YHPopupView *)popupView;
            if (pv.backgroundViewColor) {
                backgroundView.backgroundColor = pv.backgroundViewColor;
            }
            if (pv.clickBlankSpaceDismiss) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_dismissPopupView)];
                tap.delegate = self;
                [overlayView addGestureRecognizer:tap];
            }
        }
        
        self.overlayView = overlayView;
    }
    [self.overlayView addSubview:popupView];
    [sourceView addSubview:self.overlayView];
    self.overlayView.alpha = 1.0f;
}

- (UIView *)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == BackgoundViewTag) {
        return YES;
    }
    return NO;
}

@end
