//
//  UIButton+EnlargeTouchArea.h
//  手艺日历
//
//  Created by Leon on 2018/12/7.
//  Copyright © 2018 TagDesign-MBP. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EnlargeTouchArea)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

/** 设置可点击范围到按钮边缘的距离 */
- (void)setEnlargeEdge:(CGFloat)size;
/*
 上面这个方法 objc_getAssociatedObject同样也是一个关联API(c语言函数)，它可以通过刚刚设置的Key找到上个方法中从外界传入的top、right、bottom、left，这个api和obj_setAssociatedObject一起使用就可以达到给已有类扩展属性的效果。最后我们通过self.bounds设置一个新的CGRect，作为扩大后的点按区域，并且返回
 */
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
/*
 上面这个方法里 objc_setAssociatedObject是一个C语言函数，这个函数被称之为“关联API”，它的作用是把top、right、bottom、left这四个从外界获取到的值与本类(self)关联起来，然后设置一个static char作为能够找到他们的Key
 */
@end

NS_ASSUME_NONNULL_END



