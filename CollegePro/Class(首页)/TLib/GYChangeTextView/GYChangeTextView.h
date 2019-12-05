//
//  GYChangeTextView.h
//  GYShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 GY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYChangeTextView;

@protocol GYChangeTextViewDelegate <NSObject>

- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index;

@end

@interface GYChangeTextView : UIView

@property (nonatomic, assign) id<GYChangeTextViewDelegate> delegate;

- (void)animationWithTexts:(NSArray *)textAry;
- (void)stopAnimation;

@end
