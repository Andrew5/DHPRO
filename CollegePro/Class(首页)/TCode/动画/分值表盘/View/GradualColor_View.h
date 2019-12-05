//
//  GradualColor_View.h
//  渐变色圆环
//
//  Created by Self_Improve on 17/2/24.
//  Copyright © 2017年 ZWiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradualColor_View : UIView

/**
 * 开始动画
 * percent CGFloat 百分比(0-100)
 * time CGFloat 动画时间
 */
- (void)setPercet:(CGFloat)percent withTimer:(CGFloat)time ;

@end
