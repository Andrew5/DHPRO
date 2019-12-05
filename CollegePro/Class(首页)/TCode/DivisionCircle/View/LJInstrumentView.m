//
//  LJInstrumentView.m
//  节能宝
//
//  Created by 卢杰 on 16/8/16.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "LJInstrumentView.h"

#define Calculate_radius ((self.bounds.size.height>self.bounds.size.width)?(self.bounds.size.width*0.5-self.lineWidth):(self.bounds.size.height*0.5-self.lineWidth))
#define LuCenter CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y)
@interface LJInstrumentView ()
/**
 *  圆盘开始角度
 */
@property(nonatomic,assign)CGFloat startAngle;
/**
 *  圆盘结束角度
 */
@property(nonatomic,assign)CGFloat endAngle;
/**
 *  圆盘总共弧度弧度
 */
@property(nonatomic,assign)CGFloat arcAngle;
/**
 *  线宽
 */
@property(nonatomic,assign)CGFloat lineWidth;
/**
 *  刻度值长度
 */
@property(nonatomic,assign)CGFloat scaleValueRadiusWidth;
/**
 *  速度表半径
 */
@property(nonatomic,assign)CGFloat arcRadius;
/**
 *  刻度半径
 */
@property(nonatomic,assign)CGFloat scaleRadius;
/**
 *  刻度值半径
 */
@property(nonatomic,assign)CGFloat scaleValueRadius;


@property (nonatomic, strong) CAShapeLayer *progressLayer;



@end
@implementation LJInstrumentView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
    
}
/**
 *  画弧度
 *
 *  @param startAngle  开始角度
 *  @param endAngle    结束角度
 *  @param lineWitdth  线宽
 *  @param filleColor  扇形填充颜色
 *  @param strokeColor 弧线颜色
 */
-(void)drawArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle lineWidth:(CGFloat)lineWitdth fillColor:(UIColor*)filleColor strokeColor:(UIColor*)strokeColor{
    //保存弧线宽度,开始角度，结束角度
    self.lineWidth=lineWitdth;
    self.startAngle=startAngle;
    self.endAngle=endAngle;
    self.arcAngle=endAngle-startAngle;
    self.arcRadius=Calculate_radius;
    self.scaleRadius=self.arcRadius+self.lineWidth;
    self.scaleValueRadius=self.scaleRadius-self.lineWidth;
    self.speedLabel.text=@"0%";
    
    
    UIBezierPath* outArc=[UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer* shapeLayer=[CAShapeLayer layer];
    shapeLayer.lineWidth=lineWitdth;
    shapeLayer.fillColor=filleColor.CGColor;
    shapeLayer.strokeColor=strokeColor.CGColor;
    shapeLayer.path=outArc.CGPath;
    shapeLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:shapeLayer];
}
/**
 *  画刻度
 *
 *  @param divide      刻度几等分
 *  @param remainder   刻度数
 *  @param strokeColor 轮廓填充颜色
 *  @param fillColor   刻度颜色
 */
//center:中心店，即圆心
//startAngle：起始角度
//endAngle：结束角度
//clockwise：是否逆时针
-(void)drawScaleWithDivide:(int)divide andRemainder:(NSInteger)remainder strokeColor:(UIColor*)strokeColor filleColor:(UIColor*)fillColor scaleLineNormalWidth:(CGFloat)scaleLineNormalWidth scaleLineBigWidth:(CGFloat)scaleLineBigWidth{
    
    CGFloat perAngle=self.arcAngle/divide;
    //我们需要计算出每段弧线的起始角度和结束角度
    //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
    for (NSInteger i = 0; i<= divide; i++) {
        
        CGFloat lineWidth = 10.0;
        if (i < self.speedValue) {
            lineWidth = lineWidth - 10.0 / (self.speedValue) * (self.speedValue - i);
        } else if (i > self.speedValue){
            lineWidth = lineWidth - 10.0 / (100 - self.speedValue) * (i - self.speedValue);
        }
        
        CGFloat startAngel = (self.startAngle+ perAngle * i);
        CGFloat endAngel   = startAngel + perAngle/5;
        NSLog(@"刻度中心--%f,--%f",self.center.x-self.frame.origin.x+61/2, self.center.y-self.frame.origin.y);
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.scaleRadius - (10.0 - lineWidth) * 0.5 startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];

        perLayer.strokeColor = strokeColor.CGColor;
        
      
        perLayer.lineWidth = lineWidth;
        
        NSLog(@"最长刻度--%f",scaleLineBigWidth);
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
        
    }
}
/**
 *  画刻度值，逆时针设定label的值，将整个仪表切分为N份，每次递增仪表盘弧度的N分之1
 *
 *  @param divide 刻度值几等分
 */
-(void)DrawScaleValueWithDivide:(NSInteger)divide{
    CGFloat textAngel =self.arcAngle/divide;
    if (divide==0) {
        return;
    }
    for (NSUInteger i = 0; i <= divide; i++) {
        CGPoint point = [self calculateTextPositonWithArcCenter:LuCenter Angle:-(self.endAngle-textAngel*i)];
        NSString *tickText = [NSString stringWithFormat:@"%ld%%",(divide - i)*100/divide];
        //默认label的大小23 * 14
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 8, point.y - 7, 30, 14)];
        text.text = tickText;
        text.font = [UIFont systemFontOfSize:10.f];
        text.textColor = [UIColor redColor];
        text.textAlignment = NSTextAlignmentLeft;
        [self addSubview:text];
    }
}
//默认计算半径-10,计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel
{
    CGFloat x = (self.scaleValueRadius+3*self.lineWidth)* cosf(angel);
    CGFloat y = (self.scaleValueRadius+3*self.lineWidth)* sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}
/**
 *  进度条曲线
 *
 *  @param fillColor   填充颜色
 *  @param strokeColor 轮廓颜色
 */
- (void)drawProgressCicrleWithfillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor{
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:LuCenter radius:self.arcRadius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    self.progressLayer = progressLayer;
    progressLayer.lineWidth = self.lineWidth+0.25f;
    progressLayer.fillColor = fillColor.CGColor;
    progressLayer.strokeColor = strokeColor.CGColor;
    progressLayer.path = progressPath.CGPath;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0.0;
    progressLayer.lineCap=kCALineCapRound;
    [self.layer addSublayer:progressLayer];
}

- (void)runSpeedProgress{
    [self.speedLabel countFrom:0 to:_speedValue withDuration:1];
    [UIView animateWithDuration:1 animations:^{
        self.progressLayer.strokeEnd = 0.01 * self->_speedValue;
    }];
    
}
/**
 *  添加渐变图层
 *
 *  @param colorGradArray 颜色数组，如果想达到红-黄-红效果，数组应该是红，黄，红
 */
-(void)setColorGrad:(NSArray*)colorGradArray{
    //渐变图层
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    //增加渐变图层，frame为当前layer的frame
    gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [gradientLayer1 setColors:colorGradArray];
    [gradientLayer1 setStartPoint:CGPointMake(0, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(1, 1)];
    [gradientLayer addSublayer:gradientLayer1];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}
/**
 *  懒加载速度只是Label
 *
 *  @return 返回速度指示表
 */
-(UILabel *)speedLabel{
    if (!_speedLabel) {
        _speedLabel=[[UICountingLabel alloc]init];
        [self addSubview:_speedLabel];
        _speedLabel.frame=CGRectMake(0, 0, Calculate_radius, Calculate_radius);
        _speedLabel.adjustsFontSizeToFitWidth=YES;
        _speedLabel.method=UILabelCountingMethodLinear;
        _speedLabel.format=@"%d%%";
        _speedLabel.textColor=[UIColor cyanColor];
        _speedLabel.textAlignment=NSTextAlignmentCenter;
        _speedLabel.center=LuCenter;
    }
    return _speedLabel;
}










@end
