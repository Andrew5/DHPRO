//
//  ZPCAshapelGradientView.m
//  A
//
//  Created by jabraknight on 2019/8/24.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "ZPCAshapelGradientView.h"
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define DEFAULT_STARTANGLE   -360  //默认开始度数
#define DEFAULT_ENDANGLE     0  //默认结束度数
#define MAX_PROGRESS_LINE_WIDTH 45 //弧线的最大宽度**
@interface ZPCAshapelGradientView ()
{
    UISlider *_slider;
    CALayer *_gradientLayer;
    
    UILabel *_smallerLabel;
}
@end
@implementation ZPCAshapelGradientView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    //默认线宽 15
    _progressLineWidth = 15;
    _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    _trackLayer.frame = self.bounds;
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [ [UIColor lightGrayColor] CGColor];
    _trackLayer.opacity = .25;
    _trackLayer.lineCap = kCALineCapRound;
    _trackLayer.lineWidth = _progressLineWidth;//线的宽度
    //
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.width/2) radius:(frame.size.width - _progressLineWidth)/2 startAngle:degreesToRadians(DEFAULT_STARTANGLE) endAngle:degreesToRadians(DEFAULT_ENDANGLE) clockwise:YES];//上面说明过了用来构建圆形
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor redColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.opacity = 1;
    _progressLayer.lineWidth = _progressLineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    
    _gradientLayer = [CALayer layer];
    
    CAGradientLayer *gradientLayerLeft =  [CAGradientLayer layer];
    gradientLayerLeft.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    [gradientLayerLeft setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor], nil]];
    [gradientLayerLeft setLocations:@[@0.15,@.85 ]];
    [gradientLayerLeft setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayerLeft setEndPoint:CGPointMake(0.5, 0)];
    [_gradientLayer addSublayer:gradientLayerLeft];
    
    CAGradientLayer *gradientLayerright =  [CAGradientLayer layer];
    [gradientLayerright setLocations:@[@.15,@.85]];
    gradientLayerright.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    [gradientLayerright setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
    [gradientLayerright setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayerright setEndPoint:CGPointMake(0.5, 1)];
    [_gradientLayer addSublayer:gradientLayerright];
    
    
    [_gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(_progressLineWidth, _progressLineWidth, frame.size.width - 2*_progressLineWidth , frame.size.width - 2*_progressLineWidth)];
    //    bgView.backgroundColor = [UIColor redColor];
    _biggerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _bgView.frame.size.width - 10, (frame.size.width - _progressLineWidth)/2 - 10)];
    _biggerLabel.textAlignment = NSTextAlignmentCenter;
    _biggerLabel.numberOfLines = 0;
    _biggerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_bgView addSubview:_biggerLabel];
    
    [self addSubview:_bgView];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, frame.size.width - 40 ,frame.size.width, 40)];
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(log) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    return self;
}
//设置线宽
- (void)setProgressLineWidth:(CGFloat)progressLineWidth{
    
    if (_progressLineWidth != progressLineWidth) {
        _progressLineWidth = progressLineWidth;
        
        if (_progressLineWidth <= MAX_PROGRESS_LINE_WIDTH) {
            _trackLayer.lineWidth = _progressLineWidth;//线的宽度
            //从新定义 轨迹  宽
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - _progressLineWidth)/2 startAngle:degreesToRadians(DEFAULT_STARTANGLE) endAngle:degreesToRadians(DEFAULT_ENDANGLE) clockwise:YES];
            _trackLayer.path =[path CGPath];
            
            //动态图像路径  跟上重新绘制的  轨迹路径  一样（不然不能完全重合）
            _progressLayer.lineWidth = _progressLineWidth;
            _progressLayer.path = [path CGPath];
            [_gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
            [self.layer addSublayer:_gradientLayer];
            
        }else{
            
            _trackLayer.lineWidth = MAX_PROGRESS_LINE_WIDTH;//最大线的宽度
            //从新定义 轨迹  宽
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - MAX_PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(DEFAULT_STARTANGLE) endAngle:degreesToRadians(DEFAULT_ENDANGLE) clockwise:YES];
            _trackLayer.path =[path CGPath];
            
            //动态图像路径  跟上重新绘制的  轨迹路径  一样（不然不能完全重合）
            _progressLayer.lineWidth = MAX_PROGRESS_LINE_WIDTH;
            _progressLayer.path = [path CGPath];
            [_gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
            [self.layer addSublayer:_gradientLayer];
            
            
        }
        
    }
    
}

//设置 圆环的角度
- (void)setStartAngle:(CGFloat)startAngle{
    
    if ([NSString stringWithFormat:@"%f",_endAngle] == nil) {
        
        if (_startAngle != startAngle) {
            _startAngle = startAngle;
            //从新定义 开始 角度
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - MAX_PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(DEFAULT_ENDANGLE) clockwise:YES];
            _trackLayer.path =[path CGPath];
            _progressLayer.path = [path CGPath];
            
            
        }
    }else{
        
        if (_startAngle != startAngle) {
            _startAngle = startAngle;
            //从新定义 开始 角度
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - MAX_PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
            _trackLayer.path =[path CGPath];
            _progressLayer.path = [path CGPath];
            
            
        }
    }
    
}
- (void)setEndAngle:(CGFloat)endAngle{
    
    if ([NSString stringWithFormat:@"%f",_startAngle] == nil) {
        
        if (_endAngle != endAngle) {
            _endAngle = endAngle;
            //从新定义 结束 角度
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - MAX_PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(DEFAULT_STARTANGLE) endAngle:degreesToRadians(_endAngle) clockwise:YES];
            _trackLayer.path =[path CGPath];
            _progressLayer.path = [path CGPath];
        }
        
    }else{
        
        if (_endAngle != endAngle) {
            _endAngle = endAngle;
            //从新定义 结束 角度
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width - MAX_PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle) clockwise:YES];
            _trackLayer.path =[path CGPath];
            _progressLayer.path = [path CGPath];
        }
        
    }
}
//设置大标题
-(void)setBiggerTitle:(NSString *)biggerTitle{
    
    if (_biggerTitle != biggerTitle) {
        _biggerTitle = biggerTitle;
        _biggerLabel.text = _biggerTitle;
    }
}
- (void)setSmallerTitle:(NSString *)smallerTitle{
    
    if (_smallerTitle != smallerTitle) {
        _smallerTitle = smallerTitle;
        
    }
}

-(void)log{
    
    _progressLayer.strokeEnd = _slider.value;
    
    NSString *num = [NSString stringWithFormat:@"%.2f",_slider.value*100];
    NSString *fuhao = @"%";
    _biggerLabel.text = [NSString stringWithFormat:@"%@%@",num,fuhao];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
