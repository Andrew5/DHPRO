//
//  MyCreView.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/5.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "MyCreView.h"
#import "UIColor+expanded.h"
@interface MyCreView ()
{
    UIView *pointView ;
    CGFloat angle;//总弧度
    NSMutableArray *scaleLayer;
    CAGradientLayer *gradientLayer2;
    CAShapeLayer *layer9;//内圆的进度
    CAShapeLayer *layer5;//内圆左边的线
    CAShapeLayer *layer6;//内圆右边的线
    CGFloat perAngle;
    CGFloat backAngle;
}
//刻度数目
@property (nonatomic,assign)int scaleNumber;
//开始弧度
@property (nonatomic,assign)CGFloat start;
//结束弧度
@property (nonatomic,assign)CGFloat end;
@end
@implementation MyCreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#272547"];
        _progressColor = [UIColor blueColor];
        _scaleNumber = number;
        _start = M_PI*5/6+M_PI/12;
        _end = M_PI/6-M_PI/12;
        angle = M_PI*4/3-M_PI/12*2;//M_PI+M_PI/6+M_PI/6-M_PI/12*2  计算总弧度
        perAngle = angle/(_scaleNumber-1);//根据数量计算每个刻度占的弧度
        [self createUI];
    }
    return self;
}

- (void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor = progressColor;
    layer9.strokeColor = _progressColor.CGColor;
    pointView.backgroundColor = _progressColor;
    [self updateLineColor];
}

- (void)createUI{
    
    [self drawCircle];
    [self drawScale:[UIColor whiteColor] AndNumber:0];
    [self drawProgressCircle];
    [self drawLine];
    [self drawPointer];
    [self drawOther];
}

- (void)drawOther{
    
    //画圆心
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius4 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *layer4 = [[CAShapeLayer alloc]init];
    layer4. fillColor = nil;
    layer4.strokeColor = [UIColor whiteColor].CGColor;
    layer4.path = path4.CGPath;
    layer4.lineWidth = 1;
    [self.layer addSublayer:layer4];
    
    //下边的圆
    UIBezierPath *path8 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius3 startAngle:M_PI*3/4 endAngle:M_PI/4 clockwise:NO];
    CAShapeLayer *layer8 = [[CAShapeLayer alloc]init];
    layer8. fillColor = nil;
    layer8.strokeColor = [UIColor greenColor].CGColor;
    layer8.path = path8.CGPath;
    layer8.lineWidth = 10;
    [self.layer addSublayer:layer8];
    
}

- (void)drawPointer{
    
    //画指针
    pointView = [[UIView alloc]initWithFrame:CGRectMake(self.center.x-radius4/4, self.center.y-radius1, radius4/2, radius1)];
    pointView.backgroundColor = _progressColor;
    [self addSubview:pointView];
    
    UIBezierPath *path7 = [UIBezierPath bezierPath];
    //    [path7 moveToPoint:CGPointMake(self.center.x-radius4/4, self.center.y)];
    //    [path7 addLineToPoint:CGPointMake(self.center.x+radius4/4, self.center.y)];
    //    [path7 addLineToPoint:CGPointMake(self.center.x, self.center.y-radius1)];
    //    [path7 closePath];
    [path7 moveToPoint:CGPointMake(pointView.frame.size.width/2, 0)];
    [path7 addLineToPoint:CGPointMake(0, pointView.frame.size.height)];
    [path7 addLineToPoint:CGPointMake(pointView.frame.size.width, pointView.frame.size.height)];
    [path7 closePath];
    
    CAShapeLayer *layer7 = [[CAShapeLayer alloc]init];
    layer7.frame = pointView.bounds;
    layer7.path = path7.CGPath;
    pointView.layer.mask = layer7;
    CGRect oldFrame = pointView.frame;
    pointView.layer.anchorPoint = CGPointMake(0.5, 1);
    pointView.frame = oldFrame;
    pointView.transform = CGAffineTransformMakeRotation(-angle/2);
}

- (void)drawLine{
    
    //内圆两边的线
    CGFloat startAngel = _start;
    CGFloat endAngel = startAngel+perAngle/5;//刻度线的宽度
    UIBezierPath *path5 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius3+10 startAngle:startAngel endAngle:endAngel clockwise:YES];
    layer5 = [CAShapeLayer layer];
    layer5.strokeColor = [UIColor whiteColor].CGColor;
    layer5.lineWidth = 20;
    layer5.path = path5.CGPath;
    [self.layer addSublayer:layer5];
    
    CGFloat startAngel1 = _end-perAngle/5;
    CGFloat endAngel1  = startAngel1+perAngle/5;//刻度线的宽度
    UIBezierPath *path6 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius3+10 startAngle:startAngel1 endAngle:endAngel1 clockwise:YES];
    layer6 = [CAShapeLayer layer];
    layer6.strokeColor = [UIColor whiteColor].CGColor;
    layer6.lineWidth = 20;
    layer6.path = path6.CGPath;
    [self.layer addSublayer:layer6];
}
- (void)drawProgressCircle{
    
    //画内圆
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius3 startAngle:_start endAngle:_end clockwise:YES];
    CAShapeLayer *layer3 = [[CAShapeLayer alloc]init];
    layer3. fillColor = nil;
    layer3.strokeColor = [UIColor whiteColor].CGColor;
    layer3.path = path3.CGPath;
    layer3.lineWidth = 1;
    [self.layer addSublayer:layer3];
    //添加颜色渐变
    //    gradientLayer2 = [[CAGradientLayer alloc]init];
    //    gradientLayer2.colors = @[(__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    //    gradientLayer2.locations = @[@0.5,@1.0];
    //    gradientLayer2.startPoint = CGPointMake(0, 0.5);
    //    gradientLayer2.endPoint = CGPointMake(0.5, 1);
    //    gradientLayer2.frame = self.bounds;
    //    gradientLayer2.mask = layer3;
    //    [self.layer addSublayer:gradientLayer2];
    
    //绘制进度
    layer9 = [CAShapeLayer layer];
    layer9.lineWidth = 1;
    layer9.fillColor  = [UIColor clearColor].CGColor;
    layer9.strokeColor = _progressColor.CGColor;
    layer9.path = path3.CGPath;
    layer9.strokeStart = 0.0;
    layer9.strokeEnd = 0.0;
    layer9.lineCap=kCALineCapRound;
    [self.layer addSublayer:layer9];
}
- (void)drawCircle{
    //绘制外围圆
    UIBezierPath *path1  = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius1 startAngle:M_PI*5/6 endAngle:M_PI/6 clockwise:YES];
    
    CAShapeLayer *layer1 = [[CAShapeLayer alloc]init];
    layer1. fillColor = nil;
    layer1.strokeColor = [UIColor whiteColor].CGColor;
    layer1.path = path1.CGPath;
    layer1.lineWidth = 3;
    [self.layer addSublayer:layer1];
    //添加颜色渐变
    CAGradientLayer *gradientLayer1 = [[CAGradientLayer alloc]init];
    gradientLayer1.colors = @[(__bridge id)[UIColor colorWithHexString:@"#2B294B"].CGColor, (__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor colorWithHexString:@"#2B294B"].CGColor];
    gradientLayer1.locations = @[@0.01, @0.99, @1.0];
    gradientLayer1.startPoint = CGPointMake(0.5, 1);
    gradientLayer1.endPoint = CGPointMake(0.5, 0);
    gradientLayer1.frame = self.bounds;
    gradientLayer1.mask = layer1;
    [self.layer addSublayer:gradientLayer1];
    
}
//绘制刻度盘
- (void)drawScale:(UIColor*)color AndNumber:(int)scaleN{
    
    for (int i = 0; i<_scaleNumber; i++) {
        CGFloat startAngel = _start+perAngle*i;
        CGFloat endAngel = startAngel + perAngle/5;//刻度线的宽度
        UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius2 startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *layer2 = [CAShapeLayer layer];
        if (i<(scaleN+1)) {
            layer2.strokeColor = color.CGColor;
        }else{
            layer2.strokeColor = [UIColor whiteColor].CGColor;
        }
        
        if (i%5==0) {
            layer2.lineWidth =  15;
            CGPoint point = [self calculateTextPositonWithArcCenter:CGPointMake(self.center.x, self.center.y) Angle:startAngel];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-10, point.y-5, 18, 18)];
            label.text = [NSString stringWithFormat:@"%d",i/5*5];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }else{
            layer2.lineWidth =  7.5;
        }
        layer2.path = path2.CGPath;
        [self.layer addSublayer:layer2];
        [scaleLayer addObject:layer2];
    }
}


- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = (radius2-20) * cosf(angel);
    CGFloat y = (radius2-20) * sinf(angel);
    
    return CGPointMake(center.x + x, center.y + y);
}

- (void)progress:(CGFloat)value{
    
    CGFloat ang = angle*value/100-angle/2;
    
    NSLog(@"ang:%f",RADIANS_TO_DEGREES(ang));
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        layer9.strokeEnd = value/100;
        [self updateLineColor];
        [self updateScale:value];
        pointView.transform = CGAffineTransformMakeRotation(ang);
    }];
    backAngle = ang;
}

- (void)updateScale:(int)value{
    
    for (CAShapeLayer *layer in scaleLayer) {
        [layer removeFromSuperlayer];
    }
    [self drawScale:_progressColor AndNumber:value];
}

- (void)updateLineColor{
    
    if (layer9.strokeEnd>0) {
        layer5.strokeColor = _progressColor.CGColor;
    }else{
        layer5.strokeColor = [UIColor whiteColor].CGColor;
    }
    if (layer9.strokeEnd == 1.0) {
        layer6.strokeColor =  _progressColor.CGColor;
    }else{
        layer6.strokeColor = [UIColor whiteColor].CGColor;
    }
}
@end
