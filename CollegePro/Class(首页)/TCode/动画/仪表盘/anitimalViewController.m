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
@property (nonatomic, weak) GradualColor_View *gradualView;
@property (nonatomic, weak) CAShapeLayer *firstCircleShapeLayer;
@property (nonatomic, strong) UIImageView *firstCircle;
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
