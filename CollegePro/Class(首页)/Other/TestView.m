//
//  TestView.m
//  15
//
//  Created by jabraknight on 2019/4/24.
//  Copyright © 2019 大爷公司. All rights reserved.
//

#import "TestView.h"
@interface TestView()
@property (nonatomic, assign)CGPoint applePoint;

@end


@implementation TestView
- (void)showAnNewPoint{
    _applePoint =CGPointMake(330,97.5);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint bPoints[2];//坐标点
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    bPoints[0] = _applePoint;
    bPoints[0].x = _applePoint.x + ([UIScreen mainScreen].bounds.size.width / 25.0) / 2;
    bPoints[1] = _applePoint;
    bPoints[1].x = _applePoint.x + ([UIScreen mainScreen].bounds.size.width / 25.0) / 2;
    CGContextSetLineWidth(context, ([UIScreen mainScreen].bounds.size.width / 25.0) * 1.5);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddLines(context, bPoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}


@end
