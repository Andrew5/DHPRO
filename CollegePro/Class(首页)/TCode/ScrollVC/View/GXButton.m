//
//  GXButton.m
//  TextView
//
//  Created by 黄定师 on 2018/3/30.
//  Copyright © 2018年 黄定师. All rights reserved.
//

#import "GXButton.h"

@implementation GXButton

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    CGFloat scaleFont = 1.0;
    UIColor *fontColor = [UIColor blackColor];
    if (selected) {
        scaleFont = 1.3;
        fontColor = [UIColor redColor];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.titleLabel setFont:[UIFont systemFontOfSize:17 * scaleFont]];
        [self setTitleColor:fontColor forState:(UIControlStateNormal)];
    }];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//    // 定义绘图图层
//    CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
//    // 设置画笔粗细
//    mask.lineWidth = 1.0;
//    // 设置画笔线帽
//    mask.lineCap = kCALineCapSquare;
//    // 设置边框颜色
//    mask.strokeColor = [UIColor redColor].CGColor;
//    // 定义绘制路径
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
//
//    mask.path = path.CGPath;
//    // 控件添加图层
//    [self.layer addSublayer:mask];
//}


@end
