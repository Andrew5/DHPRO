//
//  GradualColor_View.m
//  渐变色圆环
//
//  Created by Self_Improve on 17/2/24.
//  Copyright © 2017年 ZWiOS. All rights reserved.
//

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 80 //圆直径
#define PROGRESS_LINE_WIDTH 25 //弧线的宽度
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "GradualColor_View.h"

@interface GradualColor_View ()

@property (nonatomic, weak) CAShapeLayer *progressLayer;

@end

@implementation GradualColor_View


- (void)drawRect:(CGRect)rect {
    // 创建一个tracker(轨道layer)
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = rect;
    [self.layer addSublayer:trackLayer];
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = [UIColor whiteColor].CGColor;
    // 背景透明度
    trackLayer.opacity = 0.6f;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = PROGRESS_LINE_WIDTH;
    // 创建轨道
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:rect.size.width / 2 - PROGRESS_LINE_WIDTH / 2 startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];
    trackLayer.path = [path CGPath];
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:rect.size.width / 2 - PROGRESS_LINE_WIDTH / 2 startAngle:degreesToRadians(PROGRESS_LINE_WIDTH / 2 - 90) endAngle:degreesToRadians(270 - PROGRESS_LINE_WIDTH / 2) clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = rect;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    progressLayer.path = [path CGPath];
    progressLayer.strokeEnd = 0;
    self.progressLayer = progressLayer;
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, rect.size.width / 2, rect.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x3333cc) CGColor],(id)[UIColorFromRGB(0x33ffcc) CGColor],(id)[UIColorFromRGB(0xEE0000) CGColor], nil]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(rect.size.width / 2, 0, rect.size.width / 2, rect.size.height);
     [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0x33ff66) CGColor],(id)[UIColorFromRGB(0x33ffcc) CGColor],(id)[UIColorFromRGB(0x3333cc) CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    // progressLayer来截取渐变层, fill是clear stroke有颜色
    [gradientLayer setMask:progressLayer];
    [self.layer addSublayer:gradientLayer];
}

- (void)setPercet:(CGFloat)percent withTimer:(CGFloat)time {
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:time];
    _progressLayer.strokeEnd = percent / 100.0f;
    [CATransaction commit];
}

@end
