//
//  YHView.m
//  CollegePro
//
//  Created by jabraknight on 2019/11/20.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "YHView.h"

@implementation YHView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
// 1、
//    // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    // 渐变色的颜色
//    NSArray *colorArr = @[
//                          (id)[UIColor blueColor].CGColor,
//                          (id)[UIColor yellowColor].CGColor
//                          ];
//
//    // CGGradientCreateWithColors(CGColorSpaceRef __nullable space, CFArrayRef cg_nullable colors, const CGFloat * __nullable locations)
//    // 通过成对的颜色值(colors)和位置(locations)创建一个渐变色，colors是一个由CGColor对象组成的非空数组，如果space非空，所有颜色都会转换到该色彩空间，并且渐变将绘制在这个色彩空间里面；否则（space为NULL），每一种颜色将会被转换并且绘制在一般的RGB色彩空间中。如果locations为NULL，第一个颜色在location 0，最后一个颜色在location 1， 并且中间的颜色将会等距分布在中间。locations中的每一个location应该是一个0~1之间的CGFloat值；locations数字的元素数量应该跟colors中的一样，如果没有颜色提供给0或者1，这个渐变将使用location中最靠近0或者1的颜色值
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArr, NULL);
//    // 释放色彩空间
//    CGColorSpaceRelease(colorSpace);
//    colorSpace = NULL;
//
//    // 获取当前context
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    // CGContextDrawLinearGradient(CGContextRef cg_nullable c, CGGradientRef cg_nullable gradient, CGPoint startPoint, CGPoint endPoint, CGGradientDrawingOptions options)
//    // 在当前context的裁剪的区域中，填充一个从startPoint到endPoint的线性渐变颜色。渐变色中location 0对应着startPoint；location 1对应着endPoint；颜色将根据locations的值线性插入在这两点（startPoint,endPoint）之间。option标志控制在startPoint之前和endPoint之后时候填充颜色。（跟开始的颜色还有最后的颜色相同）
//    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, rect.size.height / 2), CGPointMake(rect.size.width, rect.size.height / 2), 0);
//
//    //CGContextDrawRadialGradient(CGContextRef cg_nullable c,CGGradientRef cg_nullable gradient, CGPoint startCenter, CGFloat startRadius,CGPoint endCenter, CGFloat endRadius, CGGradientDrawingOptions options)
//    // 绘制一个放射性渐变色，参数基本如CGContextDrawLinearGradient，（startCenter, startRadius）分别为开始的圆心与半径，决定location 0绘制的位置，（endCenter, endRadius）则对应location 1的位置
//    // CGContextDrawRadialGradient(ctx, gradient, CGPointMake(rect.size.width / 2, rect.size.height / 2), 0, CGPointMake(rect.size.width / 2, rect.size.height / 2), MIN(rect.size.width / 2, rect.size.height / 2), 0);
//
//    // 释放gradient
//    CGGradientRelease(gradient);
//    gradient = NULL;
    
// 2、
//    // 获取当前context
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    // 设置线的宽度
//    CGContextSetLineWidth(ctx, 10);
//    // 设置线条端点为圆角
//    //kCGLineCapButt 端点什么都不绘制(默认),kCGLineCapRound 端点为圆角,kCGLineCapSquare 端点为方角(跟kCGLineCapButt很像)
//    CGContextSetLineCap(ctx, kCGLineCapRound);
//    // 设置画笔颜色
//    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGFloat originX = rect.size.width / 2;
//    CGFloat originY = rect.size.height / 2;
//    // 计算半径
//    CGFloat radius = MIN(originX, originY) - 10.0;
//    // CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y, CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
//    // 画一个圆弧作为context的路径，(x, y)是圆弧的圆心；radius是圆弧的半径；`startAngle' 是开始点的弧度;`endAngle' 是结束位置的弧度;（此处开始位置为屏幕坐标轴x轴正轴方向）; clockwise 为1是，圆弧是逆时针，0的时候就是顺时针。startAngle跟endAngle都是弧度制
//    // 逆时针画一个圆弧
//    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, 0, M_PI_2, 1);
//    CGContextStrokePath(ctx);
    
    //3
    // 1. 还是添加一个圆弧路径
    // 获取当前context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置线的宽度
    CGContextSetLineWidth(ctx, 10);
    // 设置线条端点为圆角
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // 设置画笔颜色
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGFloat originX = rect.size.width / 2;
    CGFloat originY = rect.size.height / 2;
    // 计算半径
    CGFloat radius = MIN(originX, originY) - 10.0;
    // 逆时针画一个圆弧
    CGContextAddArc(ctx, rect.size.width / 2, rect.size.height / 2, radius, 0, M_PI * 2, 1);
    
    // 2. 创建一个渐变色
    // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 渐变色的颜色
    NSArray *colorArr = @[
                          (id)[UIColor blueColor].CGColor,
                          (id)[UIColor yellowColor].CGColor
                          ];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArr, NULL);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    
    // ----------以下为重点----------
    // 3. "反选路径"
    // CGContextReplacePathWithStrokedPath
    // 将context中的路径替换成路径的描边版本，使用参数context去计算路径（即创建新的路径是原来路径的描边）。用恰当的颜色填充得到的路径将产生类似绘制原来路径的效果。你可以像使用一般的路径一样使用它。例如，你可以通过调用CGContextClip去剪裁这个路径的描边
    CGContextReplacePathWithStrokedPath(ctx);
    // 剪裁路径
    CGContextClip(ctx);
    
    // 4. 用渐变色填充
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, rect.size.height / 2), CGPointMake(rect.size.width, rect.size.height / 2), 0);
    // 释放渐变色
    CGGradientRelease(gradient);
}


@end
