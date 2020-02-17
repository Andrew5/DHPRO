//
//  DrawBezierPathView.m
//  B
//
//  Created by jabraknight on 2020/1/14.
//  Copyright © 2020 jabraknight. All rights reserved.
//

#import "DrawBezierPathView.h"

@implementation DrawBezierPathView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    /*
     从0°的点开始顺时针数算是正方向的角度，用正数表示
     从0°的点开始逆时针数算是反方向的角度，用负数表示
     所以，在圆上的一个角度，可以同时有两种表示方法，顺时针方向数一种，逆时针方向数一种，讲到这里先别慌，我们现在只要知道怎么在圆上表示一个弧度就行。
     */
    //坐标的orign
    CGPoint line_start = CGPointMake(0, 30);
    CGPoint line_end = CGPointMake(100, 30);
    //圆心所在位置
    CGPoint circle_center = CGPointMake(85, 15);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //画直线
    [path moveToPoint:line_start];
    [path addLineToPoint:line_end];
    
    // 注意线画到这里其实只画了一条直线，但是调用addArcWithCenter方法路径会自动连线到圆弧的起点
    /*
     center 圆心的坐标
     radius 圆的半径
     startAngle 起始的弧度
     endAngle：结束的弧度
     clockwise：YES为顺时针，No为逆时针
     */
    [path addArcWithCenter:circle_center radius:10 startAngle:0.25 * M_PI endAngle:- 1.5 * M_PI clockwise:NO];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;//填充颜色
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;//边框颜色
    shapeLayer.lineCap = @"round";
    shapeLayer.lineDashPhase = 2;
    shapeLayer.lineWidth = 1;
    [self.layer addSublayer:shapeLayer];
}


@end
