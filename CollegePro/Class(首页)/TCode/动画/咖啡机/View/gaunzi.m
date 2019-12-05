//
//  gaunzi.m
//  动画练习
//
//  Created by uniubi on 2017/3/16.
//  Copyright © 2017年 uniubi. All rights reserved.
//
#import <UIKit/UIKitDefines.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "gaunzi.h"
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
#define pi 3.14159265359

@implementation gaunzi

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    UIColor *color = [UIColor colorWithRed:246/255.0 green:184/255.0 blue:77/255.0 alpha:1.0];
    [color set];  //设置线条颜色
    
    _apath = [UIBezierPath bezierPath];
    
    _apath.lineWidth = 10.0;
    _apath.lineCapStyle = kCGLineCapRound;  //线条拐角
    _apath.lineJoinStyle = kCGLineCapSquare;  //终点处理
    
    [_apath moveToPoint:CGPointMake(71, 236)];
    
//    [_apath addQuadCurveToPoint:CGPointMake(149, 345) controlPoint:CGPointMake(63, 365)];
    [_apath addCurveToPoint:CGPointMake(149, 345) controlPoint1:CGPointMake(68, 345) controlPoint2:CGPointMake(71, 345)];
    
    [_apath stroke];
    
    
    
    _apath1 = [UIBezierPath bezierPath];
    
    _apath1.lineWidth = 10.0;
    _apath1.lineCapStyle = kCGLineCapRound;  //线条拐角
    _apath1.lineJoinStyle = kCGLineCapSquare;  //终点处理
    [_apath1 moveToPoint:CGPointMake(148, 235)];
    
    [_apath1 addQuadCurveToPoint:CGPointMake(152, 284) controlPoint:CGPointMake(140, 270)];
    
    [_apath1 stroke];
    
    
    
    
    _apath2 = [UIBezierPath bezierPath];
    
    _apath2.lineWidth = 10.0;
    _apath2.lineCapStyle = kCGLineCapRound;  //线条拐角
    _apath2.lineJoinStyle = kCGLineCapSquare;  //终点处理

    [_apath2 moveToPoint:CGPointMake(227, 235)];
    
    [_apath2 addQuadCurveToPoint:CGPointMake(214, 280) controlPoint:CGPointMake(230, 270)];
    
    [_apath2 stroke];
    

    
    
    
    _apath3 = [UIBezierPath bezierPath];
    
    _apath3.lineWidth = 10.0;
    _apath3.lineCapStyle = kCGLineCapRound;  //线条拐角
    _apath3.lineJoinStyle = kCGLineCapSquare;  //终点处理

    [_apath3 moveToPoint:CGPointMake(303, 235)];
    
    [_apath3 addCurveToPoint:CGPointMake(224, 319) controlPoint1:CGPointMake(303, 319) controlPoint2:CGPointMake(303, 319)];
    
    [_apath3 stroke];
    
    UIColor *color1 = [UIColor colorWithRed:168/255.0 green:216/255.0 blue:244/255.0 alpha:1.0];
    [color1 set];  //设置线条颜色
    
   _apath4 = [UIBezierPath bezierPath];
    
    _apath4.lineWidth = 4.0;
    _apath4.lineCapStyle = kCGLineCapRound;  //线条拐角
    _apath4.lineJoinStyle = kCGLineCapSquare;  //终点处理
    [_apath4 moveToPoint:CGPointMake(78, 475)];
    
    [_apath4 addCurveToPoint:CGPointMake(157, 375) controlPoint1:CGPointMake(78, 375)controlPoint2:CGPointMake(78, 375)];
    
    [_apath4 stroke];
    
    
}
@end
