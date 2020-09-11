//
//  WKPopBaseView.h
//  MKWeekly
//
//  Created by wangkun on 2017/8/2.
//  Copyright © 2017年 zymk. All rights reserved.
//

#import "WKBaseView.h"

@interface WKPopBaseView : WKBaseView

@property (nonatomic, strong) UIView * contentView;

- (void)show:(BOOL)flag;
- (void)showAndAutoDismiss;
- (void)showAndAutoDismissAfterDelay:(NSTimeInterval)second;

@end
