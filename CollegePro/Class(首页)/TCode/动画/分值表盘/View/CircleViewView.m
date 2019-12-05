//
//  CircleView.m
//  A
//
//  Created by jabraknight on 2019/8/24.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CircleViewView.h"

@implementation CircleViewView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self create];
    }
    return self;
}
- (void)create{
    //创建背景圆环
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.bounds;
    //清空填充色
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    //设置画笔颜色 即圆环背景色
    trackLayer.strokeColor =  [UIColor colorWithRed:170/255.0 green:210/255.0 blue:254/255.0 alpha:1].CGColor;
    trackLayer.lineWidth = 20;
    //设置画笔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:self.frame.size.width/2.0 - 10 startAngle:- M_PI_2 endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];
    //path 决定layer将被渲染成何种形状
    trackLayer.path = path.CGPath;
    [self.layer addSublayer:trackLayer];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = self.bounds;
    
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(width/2.0, 0, width/2.0,  height/2.0);
    gradientLayer1.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor orangeColor].CGColor];
    //startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
    //startPoint和pointEnd 分别指定颜色变换的起始位置和结束位置.
    //当开始和结束的点的x值相同时, 颜色渐变的方向为纵向变化
    //当开始和结束的点的y值相同时, 颜色渐变的方向为横向变化
    //其余的 颜色沿着对角线方向变化
    gradientLayer1.startPoint = CGPointMake(0.2, 0);
    gradientLayer1.endPoint = CGPointMake(0.8, 1);
    [gradientLayer addSublayer:gradientLayer1];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(width/2.0, width/2.0, width/2.0,  height/2.0);
    gradientLayer2.colors = @[(__bridge id)[UIColor orangeColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];
    [gradientLayer2 setLocations:@[@0.3, @0.8,@1]];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1);
    [gradientLayer addSublayer:gradientLayer2];
    
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.frame = CGRectMake(0, width/2.0, width/2.0,  height/2.0);
    gradientLayer3.colors = @[(__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    gradientLayer3.startPoint = CGPointMake(0.5, 1);
    gradientLayer3.endPoint = CGPointMake(0.5, 0);
    [gradientLayer addSublayer:gradientLayer3];
    
    CAGradientLayer *gradientLayer4 = [CAGradientLayer layer];
    gradientLayer4.frame = CGRectMake(0, 0, width/2.0,  height/2.0);
    gradientLayer4.colors = @[(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    gradientLayer4.startPoint = CGPointMake(0.5, 1);
    gradientLayer4.endPoint = CGPointMake(0.5, 0);
    [gradientLayer addSublayer:gradientLayer4];
    
    [self.layer addSublayer:gradientLayer];
    
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor  = [UIColor colorWithRed:170/255.0 green:210/255.0 blue:254/255.0 alpha:1].CGColor;
    _progressLayer.lineWidth = 20;
    _progressLayer.path = path.CGPath;
    gradientLayer.mask = _progressLayer;
    
    [gradientLayer3 setLocations:@[@0.2,@0.8]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
