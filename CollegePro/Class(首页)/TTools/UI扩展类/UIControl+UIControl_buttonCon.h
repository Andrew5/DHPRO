//
//  UIControl+UIControl_buttonCon.h
//  嘉期
//
//  Created by Leon on 2018/12/11.
//  Copyright © 2018 tagDesign. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 0.5//默认时间间隔

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (UIControl_buttonCon)
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@end

NS_ASSUME_NONNULL_END

