//
//  HAScrollLabel.m
//  仿网易新闻滚动列表
//
//  Created by haha on 15/3/19.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
+ (instancetype)DViewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
//----
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setMaxX:(CGFloat)maxX

{
	
	self.x = maxX - self.width;
	
}
- (CGFloat)maxX

{
	
	return CGRectGetMaxX(self.frame);
	
}


//----
- (void)setMaxY:(CGFloat)maxY

{
	
	self.y = maxY - self.height;
	
}
- (CGFloat)maxY

{
	
	return CGRectGetMaxY(self.frame);
	
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
//----
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}
//----
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
//----
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
//----
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
//----
- (void)setSize:(CGSize)size
{
//    self.width = size.width;
//    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

@end

@implementation UIScrollView (AdjustInsets)

- (void)setContentInsetTop:(CGFloat)contentInsetTop {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.top = contentInsetTop;
    self.contentInset = edgeInsets;
}

- (void)setContentInsetLeft:(CGFloat)contentInsetLeft {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.left = contentInsetLeft;
    self.contentInset = edgeInsets;
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.bottom = contentInsetBottom;
    self.contentInset = edgeInsets;
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight {
    UIEdgeInsets edgeInsets = self.contentInset;
    edgeInsets.right = contentInsetRight;
    self.contentInset = edgeInsets;
}

- (CGFloat)contentInsetTop {
    return self.contentInset.top;
}

- (CGFloat)contentInsetLeft {
    return self.contentInset.left;
}

- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (CGFloat)contentInsetRight {
    return self.contentInset.right;
}

@end
