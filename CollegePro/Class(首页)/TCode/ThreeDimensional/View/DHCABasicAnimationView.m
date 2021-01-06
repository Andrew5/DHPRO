//
//  DHCABasicAnimationView.m
//  CollegePro
//
//  Created by jabraknight on 2021/1/6.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "DHCABasicAnimationView.h"
@interface DHCABasicAnimationView ()<CAAnimationDelegate>{
    UILabel *animationView;
}
@end
@implementation DHCABasicAnimationView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    animationView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 15*4, 20)];
    animationView.backgroundColor = [UIColor blueColor];
    animationView.textAlignment = NSTextAlignmentCenter;
    animationView.text = @"张明炜";
    animationView.textColor = [UIColor redColor];
    [self addSubview:animationView];
    [self 动画1];
}
- (void)动画1{
    //闪烁效果。
    [animationView.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    //移动的动画。
    [animationView.layer addAnimation:[self moveX:1.0f X:[NSNumber numberWithFloat:200.0f]] forKey:nil];
    //缩放效果。
    [animationView.layer addAnimation:[self scale:[NSNumber numberWithFloat:1.0f] orgin:[NSNumber numberWithFloat:2.0f] durTimes:.5f Rep:MAXFLOAT] forKey:nil];
    //组合动画。
    NSArray *myArray = [NSArray arrayWithObjects:[self opacityForever_Animation:0.5],[self moveX:1.0f X:[NSNumber numberWithFloat:200.0f]],[self scale:[NSNumber numberWithFloat:1.0f] orgin:[NSNumber numberWithFloat:3.0f] durTimes:2.0f Rep:MAXFLOAT], nil];
    [animationView.layer addAnimation:[self groupAnimation:myArray durTimes:3.0f Rep:MAXFLOAT] forKey:nil];
//    //路径动画。
//    CGMutablePathRef myPah = CGPathCreateMutable();
//    CGPathMoveToPoint(myPah, nil,30, 77);
//    CGPathAddCurveToPoint(myPah, nil, 50, 50, 60, 200, 200, 200);//这里的是控制点。
//    [animationView.layer addAnimation:[self keyframeAnimation:myPah durTimes:5 Rep:MAXFLOAT] forKey:nil];
    //旋转动画。
    [animationView.layer addAnimation:[self rotation:2 degree:kRadianToDegrees(90) direction:1 repeatCount:MAXFLOAT] forKey:nil];
}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}
 
#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
 
#pragma mark =====缩放-=============
-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}
 
#pragma mark =====组合动画-=============
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes {
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
 
#pragma mark =====路径动画-=============
-(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;
    return animation;
}
 
#pragma mark ====旋转动画======
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount {
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
 
    return animation;
}
- (void)animationDidStart:(CAAnimation *)anim{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}
@end
