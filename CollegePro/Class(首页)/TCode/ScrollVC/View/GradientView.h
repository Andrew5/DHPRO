//
//  GradientView.h
//  GiftBox
//
//  Created by 康健 on 16/1/15.
//  Copyright © 2016年 xinyihezi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientViewType) {
    /** 水平渐变 */
            kGradientViewTypeHorizontal = 0,
    /** 竖直渐变 */
            kGradientViewTypeVertical = 1,
    /** 左斜渐变 */
            kGradientViewTypeInclinedLeft = 2,
    /** 右斜渐变 */
            kGradientViewTypeInclinedRight = 3
};

/** 渐变颜色的UIView */
@interface GradientView : UIView
/** 起始颜色 */
@property(nonatomic, strong) IBInspectable UIColor *startColor;
/** 结束颜色 */
@property(nonatomic, strong) IBInspectable UIColor *endColor;
/** 渐变类型 */
@property(nonatomic, assign) IBInspectable int gradientViewType;
/** 起始的偏移量 默认是0 */
@property(nonatomic, assign) IBInspectable CGFloat startOffset;

- (id)initWithFrame:(CGRect)frame startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)removeGradient;
@end
