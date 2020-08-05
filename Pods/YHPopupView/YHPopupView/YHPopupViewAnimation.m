//
//  YHPopupViewAnimation.m
//  YHPopupView
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "YHPopupViewAnimation.h"

@interface YHPopupViewAnimation()

@property (nonatomic, assign) CGRect popupStartRect;
@property (nonatomic, assign) CGRect popupEndRect;
@property (nonatomic, assign) CGRect dismissEndRect;

@end


@implementation YHPopupViewAnimation

- (id) initWithPopupStartRect:(CGRect)popupStartRect popupEndRect:(CGRect)popupEndRect dismissEndRect:(CGRect)dismissEndRect{
    
    self.popupStartRect = popupStartRect;
    self.popupEndRect = popupEndRect;
    self.dismissEndRect = dismissEndRect;
    return self;

}

- (void)showView:(UIView *)popupView overlayView:(UIView *)overlayView{
    
    CGRect popupStartRect = _popupStartRect;
    CGRect popupEndRect = _popupEndRect;
    
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        popupView.frame = popupEndRect;
    } completion:nil];
    
    
}
- (void)dismissView:(UIView *)popupView overlayView:(UIView *)overlayView completion:(void (^)(void))completion{

    CGRect dismissEndRect = _dismissEndRect;
    
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        popupView.frame = dismissEndRect;
        overlayView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        completion();
    }];
    
}

@end
