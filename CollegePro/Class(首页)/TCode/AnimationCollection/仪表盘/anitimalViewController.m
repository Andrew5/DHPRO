//
//  anitimalViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/2.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "anitimalViewController.h"
#import "CircleViewView.h"
#import "ZPCAshapelGradientView.h"
#import "GradualColor_View.h"
#import "YHView.h"
#define GRADUALVIE_WIDTH 200

@interface anitimalViewController ()
{
    UIBezierPath *_trackPath,*_progressPath;
    CAShapeLayer *_trackLayer,*_progressLayer;
    NSTimer *timemwe
}
@property (nonatomic, weak) GradualColor_View *gradualView;
@property (nonatomic, weak) CAShapeLayer *firstCircleShapeLayer;
@property (nonatomic, strong) UIImageView *firstCircle;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *CurvedLineLayer;

@end

@implementation anitimalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CircleViewView *circle = [[CircleViewView alloc] initWithFrame:CGRectMake(80, 70, 200, 200)];
//    circle.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:circle];
//    // Do any additional setup after loading the view.
//
//    ZPCAshapelGradientView *view = [[ZPCAshapelGradientView alloc] initWithFrame:CGRectMake(40, 300, 200, 200)];
//    //    view.progressLineWidth = 90;//最大是45
//    //    view.startAngle = -210;
//    //    view.endAngle = 30;
//    //    view.biggerTitle = @"属性居中，字体大小和颜色可以改变，自身大小为半径减去线宽，最好是 字少一些";
//    view.biggerLabel.font = [UIFont systemFontOfSize:40];
//    [self.view addSubview:view];
//
//    GradualColor_View *gradualView = ({
//        GradualColor_View *view = [[GradualColor_View alloc] initWithFrame:(CGRectMake((DH_DeviceWidth - GRADUALVIE_WIDTH) / 2, 550, GRADUALVIE_WIDTH, GRADUALVIE_WIDTH))];
//        view.backgroundColor = [UIColor clearColor];
//        view.layer.borderColor = [UIColor greenColor].CGColor;
//        view.layer.borderWidth = 1.0;
//        [self.view addSubview:view];
//        view;
//    });
//    [self.gradualView setPercet:100.0 withTimer:1.8f];
//    self.gradualView = gradualView;

///////////////////////////圆弧//////////////////////////////////////////////
    _firstCircle.frame = CGRectMake(0, 64, 200, 200);
    _firstCircle.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
    CGFloat firsCircleWidth = 5;
    self.firstCircleShapeLayer = [self generateShapeLayerWithLineWidth:firsCircleWidth];
    _firstCircleShapeLayer.path = [self generateBezierPathWithCenter:CGPointMake(100, 100) radius:100].CGPath;
    _firstCircle.layer.mask = _firstCircleShapeLayer;

    //圆环背景View
    UIView *cricleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:cricleView];
    
    //淡黄色圆环
    CAShapeLayer *fullCricleLayer = [[CAShapeLayer alloc] init];
    fullCricleLayer.strokeColor = [UIColor grayColor].CGColor;
    fullCricleLayer.fillColor = [UIColor clearColor].CGColor;
    fullCricleLayer.lineWidth = 4;
    fullCricleLayer.lineCap = kCALineCapRound;
    UIBezierPath *fullPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:45 startAngle:3.0 * M_PI_4 endAngle:M_PI_4 clockwise:YES];
    fullCricleLayer.path = fullPath.CGPath;
    [cricleView.layer addSublayer:fullCricleLayer];
    
    //表示进度的圆环
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = 5;
    maskLayer.lineCap = kCALineCapRound;
    CGFloat allCorrectPercent = 0.8;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:45 startAngle:3.0 * M_PI_4 endAngle:3.0 * M_PI_4 + 3.0 * M_PI_2 * allCorrectPercent clockwise:YES];
    maskLayer.path = path.CGPath;
    
    //渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = cricleView.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor,(id)[UIColor  greenColor].CGColor, nil]];
    gradientLayer.startPoint = [self getPointWithAngle:3.0 * M_PI_4];
    gradientLayer.endPoint = [self getPointWithAngle:3.0 * M_PI_4 + 3.0 * M_PI_2 * allCorrectPercent];
    
    [cricleView.layer addSublayer:gradientLayer];
    [gradientLayer setMask:maskLayer];
    [cricleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 300));
        make.top.mas_equalTo(self.view.mas_top).offset(300);
        make.centerX.equalTo(self.view);
    }];
    
    
    YHView *yhCircle = [[YHView alloc] initWithFrame:CGRectMake(80, 70, 200, 200)];
    //    circle.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:yhCircle];
    [self drawyuan];
}

- (void)drawyuan{
//   [self drawlayer];
    //画两个圆，其中一个圆表示进度
    [self createBezierPath:CGRectMake(100, 100, 100, 100)];
    //创建一个转动的圆
    [self circleBezierPath];
    //用定时器模拟数值输入的情况
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(circleAnimationTypeOne)
                                            userInfo:nil
                                             repeats:YES];
    //通过点画线组成一个五边线
}
-(void)circleBezierPath
{
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 150, 150);
    self.shapeLayer.position = self.view.center;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 2.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 150, 150)];
    
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.view.layer addSublayer:self.shapeLayer];
}

- (void)circleAnimationTypeOne
{
    if (self.shapeLayer.strokeEnd > 1 && self.shapeLayer.strokeStart < 1) {
        self.shapeLayer.strokeStart += 0.1;
    }else if(self.shapeLayer.strokeStart == 0){
        self.shapeLayer.strokeEnd += 0.1;
    }
    
    if (self.shapeLayer.strokeEnd == 0) {
        self.shapeLayer.strokeStart = 0;
    }
    
    if (self.shapeLayer.strokeStart == self.shapeLayer.strokeEnd) {
        self.shapeLayer.strokeEnd = 0;
    }
}

- (void)circleAnimationTypeTwo
{
    CGFloat valueOne = arc4random() % 100 / 100.0f;
    CGFloat valueTwo = arc4random() % 100 / 100.0f;
    
    self.shapeLayer.strokeStart = valueOne < valueTwo ? valueOne : valueTwo;
    self.shapeLayer.strokeEnd = valueTwo > valueOne ? valueTwo : valueOne;
}

- (void)drawlayer{
    //创建出CAShapeLayer
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 200, 200);//设置shapeLayer的尺寸和位置
    self.shapeLayer.position = self.view.center;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    //设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 1.0f;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    //设置stroke起始点
    //在这里就是起始笔和结束笔的位置,Stroke为1的话就是一整圈，0.5就是半圈，0.25就是1/4圈。
    /*
              3π/2
                丨
     第二象限     |   第一象限
     5π/4       丨   7π/4
     π ———————————————————— 2π   0
                丨
     第三象限     |   第四象限
     3π/4       丨   π/4
               π/2
     */
    ///理解为 三象限、二象限、一象限、四象限
    //逆时针
    self.shapeLayer.strokeStart = 0.25+0.25/2;
    self.shapeLayer.strokeEnd = 1;
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    //让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    //添加并显示
    [self.view.layer addSublayer:self.shapeLayer];
}
//画两个圆形
-(void)createBezierPath:(CGRect)mybound{
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 0.7)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    
    _trackLayer = [CAShapeLayer new];
    [self.view.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor=[UIColor grayColor].CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth=5;
    _trackLayer.frame = mybound;
    
    //内圆
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 0.7)/ 2+10 startAngle:- M_PI_2 endAngle:(M_PI * 2) * 0.7 - M_PI_2 clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    [self.view.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth=5;
    _progressLayer.frame = mybound;
}

//画一个五边形
-(void)fiveAnimation
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //开始点 从上左下右的点
    [aPath moveToPoint:CGPointMake(100,100)];
    //划线点
    [aPath addLineToPoint:CGPointMake(60, 140)];
    [aPath addLineToPoint:CGPointMake(60, 240)];
    [aPath addLineToPoint:CGPointMake(160, 240)];
    [aPath addLineToPoint:CGPointMake(160, 140)];
    [aPath closePath];
    //设置定点是个5*5的小圆形（自己加的）
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100-5/2.0, 0, 5, 5)];
    [aPath appendPath:path];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    //设置边框颜色
    shapelayer.strokeColor = [[UIColor redColor]CGColor];
    //设置填充颜色 如果只要边 可以把里面设置成[UIColor ClearColor]
    shapelayer.fillColor = [[UIColor blueColor]CGColor];
    //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
    shapelayer.path = aPath.CGPath;
    [self.view.layer addSublayer:shapelayer];
}

//画一条虚线
-(void)createDottedLine
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.view.bounds];
    [shapeLayer setPosition:self.view.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    // 设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
    [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:1],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 89);
    CGPathAddLineToPoint(path, NULL, 320,89);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的
    [[self.view layer] addSublayer:shapeLayer];
}

//画一个弧线
-(void)createCurvedLine
{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(20, 100)];
    [aPath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
    
    self.CurvedLineLayer=[CAShapeLayer layer];
    self.CurvedLineLayer.path=aPath.CGPath;
    [self.view.layer addSublayer:self.CurvedLineLayer];
}



- (CAShapeLayer *)generateShapeLayerWithLineWidth:(CGFloat)lineWidth
{
    CAShapeLayer *waveline = [CAShapeLayer layer];
    waveline.lineCap = kCALineCapButt;
    waveline.lineJoin = kCALineJoinRound;
    waveline.strokeColor = [UIColor redColor].CGColor;
    waveline.fillColor = [[UIColor brownColor] CGColor];
    waveline.lineWidth = lineWidth;
    waveline.backgroundColor = [UIColor yellowColor].CGColor;
    
    return waveline;
}
//根据角度来计算进度圆环的起点和终点
-(CGPoint)getPointWithAngle:(CGFloat)angle
{
    CGFloat radius = 45;//半径
    int index = (angle) / M_PI_2;
    CGFloat needAngle = angle - index * M_PI_2;
    CGFloat x = 0, y = 0;
    
    if (angle >= 3 * M_PI_2) {//第一象限
        x = radius + sinf(needAngle) * radius;
        y = radius - cosf(needAngle) * radius;
    } else if (angle >= 0 && angle < M_PI_2) {//第二象限
        x = radius + cosf(needAngle) * radius;
        y = radius + sinf(needAngle) * radius;
    } else if (angle >= M_PI_2 && angle < M_PI) {//第三象限
        x = radius - sinf(needAngle) * radius;
        y = radius + cosf(needAngle) * radius;
    } else if (angle >= M_PI && angle < 3 * M_PI_2) {//第四象限
        x = radius - cosf(needAngle) * radius;
        y = radius - sinf(needAngle) * radius;
    }
    
    CGPoint point = CGPointMake(x/100.0, y/100.0);
    return  point;
}
- (UIBezierPath *)generateBezierPathWithCenter:(CGPoint)center radius:(CGFloat)radius
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO];
    
    return circlePath;
}

- (UIImageView *)firstCircle
{
    if (!_firstCircle) {
        _firstCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open1.jpg"]];
        _firstCircle.layer.masksToBounds = YES;
        _firstCircle.alpha = 1.0;
    }
    
    return _firstCircle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
