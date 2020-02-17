//
//  BigSizeButton.h
//  zhundao
//
//  Created by zhundao on 2017/8/31.
//  Copyright © 2017年 zhundao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigSizeButton : UIButton
//可用
- (instancetype)initWithFrame:(CGRect)frame andCornerRadius:(CGFloat)cornerRadius NS_DESIGNATED_INITIALIZER;
//不可用
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
@end
