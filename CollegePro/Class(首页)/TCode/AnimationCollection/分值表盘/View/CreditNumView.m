//
//  CreditNumView.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/27.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CreditNumView.h"
#define INSIDE_RADIU  95  // 内圈半径

#define OUTSIDE_RADIU  160 // 外圈半径

#define PROGRESS_RADIU 110 // 进度条半径

//#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface CreditNumView()
@property (nonatomic, assign) CGPoint m_Center;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) CAShapeLayer *progessLineLayer;

@property (nonatomic, strong) UILabel *s_NumLabel;

@property (nonatomic, strong) UILabel *s_StausLabel;

@property (nonatomic, strong) UILabel *s_TimeLabel;

@property (nonatomic, strong) NSTimer *timer;
@end
@implementation CreditNumView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.m_Center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self initial];
    }
    return self;
}

- (void)initial
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.s_NumLabel];
    [self addSubview:self.s_StausLabel];
    [self addSubview:self.s_TimeLabel];
    [self drawInsideArc];
    [self drawOutsideBg];
    [self drawOutsideArc];
    [self drawProgreeArc];
    [self drawProgreeLineArc];
}


// 评分展示
- (UILabel *)s_NumLabel
{
    if (!_s_NumLabel) {
        _s_NumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.height/2-75, INSIDE_RADIU*2, 35)];
        _s_NumLabel.font = [UIFont boldSystemFontOfSize:32];
        _s_NumLabel.textColor = DHColor(239, 80, 59);
        _s_NumLabel.textAlignment = NSTextAlignmentCenter;
        _s_NumLabel.text = @"0";
    }
    return _s_NumLabel;
}

// 状态
- (UILabel *)s_StausLabel
{
    if (!_s_StausLabel) {
        _s_StausLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.s_NumLabel.bottom+5, INSIDE_RADIU*2, 20)];
        _s_StausLabel.font = [UIFont systemFontOfSize:18];
        _s_StausLabel.textColor = DHColor(239, 80, 59);
        _s_StausLabel.textAlignment = NSTextAlignmentCenter;
        _s_StausLabel.text = @"正常";
    }
    return _s_StausLabel;
}

// 时间
- (UILabel *)s_TimeLabel
{
    if (!_s_TimeLabel) {
        _s_TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - INSIDE_RADIU, self.s_StausLabel.bottom, INSIDE_RADIU*2, 18)];
        _s_TimeLabel.font = [UIFont systemFontOfSize:15];
        _s_TimeLabel.textColor = [UIColor lightGrayColor];
        _s_TimeLabel.textAlignment = NSTextAlignmentCenter;
        _s_TimeLabel.text = @"评估时间:2018.07.07";
    }
    return _s_TimeLabel;
}


// 内弧线
- (void)drawInsideArc
{
    //主要解释一下各个参数的意思
    //center  中心点（可以理解为圆心）
    //radius  半径
    //startAngle 起始角度
    //endAngle  结束角度
    //clockwise  是否顺时针
    
    CGFloat perAngle = M_PI / 80;
    
    for (int i = 0; i< 81; i++) {
        
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/3;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:INSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        perLayer.lineWidth   = 1.f;
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

- (void)drawOutsideBg
{
    CGFloat perAngle = M_PI / 50;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 0; i< 51; i++) {
        
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:OUTSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.lineWidth   = 30.f;
        perLayer.strokeColor = [self getBgColor:i].CGColor;
        if (i % 5 == 0) {
            [self drawOutsideScaleWithAngel:endAngel withData:i];
        }
        
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

// 获取渐变背景色
- (UIColor *)getBgColor:(NSInteger)value
{
    float one = (255 + 255) / 60;//（255+255）除以最大取值的三分之二
    int r=0,g=0,b=0;
    if (value < 30)//第一个三等分
    {
        r = 255;
        g = (int)(one * value);
    }
    else if (value >= 30 && value < 60)//第二个三等分
    {
        r =  255 - (int)((value - 30) * one);//val减最大取值的三分之一;
        g = 255;
    }
    else { g = 255; }//最后一个三等分
    return DHColor(r, g, b);
}

// 外侧弧线分割
- (void)drawOutsideArc
{
    CGFloat perAngle = M_PI / 5;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (int i = 1; i< 5; i++) {
        
        CGFloat startAngel = (-M_PI + perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/80;
        
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:self.m_Center radius:OUTSIDE_RADIU startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.lineWidth   = 30.f;
        perLayer.strokeColor = [UIColor whiteColor].CGColor;
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
    
}


// 外侧 刻度
- (void)drawOutsideScaleWithAngel:(CGFloat)textAngel withData:(int)index
{
    CGPoint point      = [self calculateTextPositonWithArcCenter:self.m_Center Angle:-textAngel];
    NSString *tickText = [NSString stringWithFormat:@"%d",index * 2];
    if (index % 10 == 0) {
        tickText = [NSString stringWithFormat:@"%d",index * 2 *10];
    }else{
        if (index == 5) {
            tickText = @"超低";
        }else if(index == 15){
            tickText = @"较低";
        }else if(index == 25){
            tickText = @"正常";
        }else if(index == 35){
            tickText = @"较高";
        }else if(index == 45){
            tickText = @"超高";
        }
    }
    
    //默认label的大小30 * 14
    UILabel *text      = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 15, point.y - 8, 30, 14)];
    text.text          = tickText;
    text.font          = [UIFont systemFontOfSize:10];
    text.textColor     = [UIColor colorWithRed:0.54 green:0.78 blue:0.91 alpha:1.0];
    text.textAlignment = NSTextAlignmentCenter;
    [self addSubview:text];
    
}


//默认计算半径135
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = 135 * cosf(angel);
    CGFloat y = 135 * sinf(angel);
    
    return CGPointMake(center.x + x, center.y - y);
}


// 绘制进度填充
- (void)drawProgreeArc
{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:self.m_Center
                                                                 radius:130
                                                             startAngle:- M_PI
                                                               endAngle:0
                                                              clockwise:YES];
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.lineWidth     =  30.f;
    self.progressLayer.fillColor     = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor   =  [UIColor colorWithRed:185/255.0f green:243/255.0f blue:110/255.0f alpha:0.2].CGColor;
    self.progressLayer.path          = progressPath.CGPath;
    self.progressLayer.strokeStart   = 0;
    self.progressLayer.strokeEnd     = 0;
    [self.layer addSublayer:self.progressLayer];
}

// 绘制进度曲线

- (void)drawProgreeLineArc
{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:self.m_Center
                                                                 radius:118
                                                             startAngle:- M_PI
                                                               endAngle:0
                                                              clockwise:YES];
    self.progessLineLayer = [CAShapeLayer layer];
    self.progessLineLayer.lineWidth     =  2.f;
    self.progessLineLayer.fillColor     = [UIColor clearColor].CGColor;
    self.progessLineLayer.strokeColor   =  DHColor(236,92,55).CGColor;
    self.progessLineLayer.path          = progressPath.CGPath;
    self.progessLineLayer.strokeStart   = 0;
    self.progessLineLayer.strokeEnd     = 0;
    [self.layer addSublayer:self.progessLineLayer];
}



- (void)setM_CreditTime:(NSString *)m_CreditTime
{
    _m_CreditTime = m_CreditTime;
    self.s_TimeLabel.text = [NSString stringWithFormat:@"评估时间:%@",m_CreditTime];
}

- (void)setM_CreditNum:(NSString *)m_CreditNum
{
    _m_CreditNum = m_CreditNum;
    
    NSString *crditStatus = @"信用分正常";
    if (m_CreditNum.floatValue <= 100) {
        crditStatus = @"信用分危险";
    }else{
        crditStatus = @"信用分正常";
    }
    self.s_StausLabel.text = crditStatus;
    [self creditAnimationBegin:0 End:m_CreditNum.floatValue];
    
    [UIView animateWithDuration:2 animations:^{
        CGFloat endStoke = self->_m_CreditNum?self->_m_CreditNum.floatValue/1000:0;
        self.progressLayer.strokeEnd = endStoke;
        self.progessLineLayer.strokeEnd = endStoke;
    }];
}


// 数字动画
- (void)creditAnimationBegin:(int)begin End:(int)end{
    
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
    
    [userinfo setObject:@(begin) forKey:@"beginNumber"];
    [userinfo setObject:@(end) forKey:@"endNumber"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/20.0 target:self selector:@selector(changeNumberAnimation:) userInfo:userinfo repeats:YES];
    
}

- (void)changeNumberAnimation:(NSTimer *)timer{
    
    int begin = [timer.userInfo[@"beginNumber"] floatValue];
    int end = [timer.userInfo[@"endNumber"] floatValue];
    int current = begin;
    current += 50;
    
    [timer.userInfo setObject:@(current) forKey:@"beginNumber"];
    if (current >= end) {
        current = end;
    }
    self.s_NumLabel.text = [NSString stringWithFormat:@"%d",current];
    
    if (current == end) {
        
        [timer invalidate];
        self.timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
