//
//  YHMessageView.h
//  YHPopupViewDemo
//
//  Created by deng on 16/12/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+YHMessageViewController.h"

@protocol YHMessageViewDelegate;

@interface YHMessageView : UIView

@property (nonatomic, weak) id <YHMessageViewDelegate> delegate;
@property (nonatomic, assign) CGFloat showTime;

@end

@protocol YHMessageViewDelegate <NSObject>

@optional

- (void)tapMessageView:(YHMessageView *)messageView;

@end
