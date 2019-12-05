//
//  RippleView.h
//  CollegePro
//
//  Created by jabraknight on 2019/9/14.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeWithBackground,
    AnimationTypeWithoutBackground
};
@interface RippleView : UIView
/**
 设置扩散倍数。默认1.423倍
 */
@property (nonatomic, assign) CGFloat multiple;

- (instancetype)initWithFrame:(CGRect)frame animationType:(AnimationType)animationType;
@end

NS_ASSUME_NONNULL_END
