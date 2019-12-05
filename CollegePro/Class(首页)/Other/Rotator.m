//
//  Rotator.m
//  15
//
//  Created by jabraknight on 2018/11/13.
//  Copyright © 2018 大爷公司. All rights reserved.
//

#import "Rotator.h"

#import <QuartzCore/QuartzCore.h>

#import <math.h>

#import <objc/runtime.h>

#define A_CIRCLE_RADIAN (2.0f*M_PI)

#define DEFAULT_MAX_ROTATE_RADIAN   (0.1f*M_PI)

#define DEFAULT_BEGIN_ROTATE_RADIN  (0.015f)

#define DEFAULT_STOP_ROTATE_RADIN   (0.015f)

#define DEFAULT_UNIFORM_DURATION    (5)

#define DEFAULT_UNIFORM_SPEED       (M_PI/20.0)

#define DEFAULT_DEC_FACTOR          (0.97f)

#define DEFAULT_UNIFORM_FACOTR      (1.0f)

#define DEFAULT_ACC_FACTOR          (1.02f)

#define DEFAULT_TIMER_INTERVAL      (1/50.0f)

#define DEFAULT_ACC_PROPORTION      (1/5.0f)

#define DEFAULT_UNI_PROPORTION      (1/5.0f)

#define DEFAULT_DEC_PROPORTION      (3/5.0f)

#define CALC_DURATION_COUNT(_dur,_pro) (1.0f/DEFAULT_TIMER_INTERVAL * (_dur) * (_pro))

#define SUM_RADIAN(_a1,_n,_q) ((_a1)*(1.0f-powf((_q),(_n)))/(1.0f-(_q)))

#define GET_MOD_RADIAN(_x) ((_x) - ((int)((_x)/A_CIRCLE_RADIAN)) * A_CIRCLE_RADIAN)

static const RadianRange NoSpecifyStopRadian = {-1,-1};


@implementation Rotator
{
    
    NSTimer * timer;
    
        CGFloat   totalRadian;
    
        CGFloat   timerInterval;
    
        CGFloat   rotateFactor;   //旋转速度渐变因子
    
        //CGFloat   defaultRadian;
    
        //int       uniformDuration;
    
        CGFloat   acceCount;
    
        CGFloat   uniformCount;
    
        CGFloat   decCount;
    
        
    
        
    
        CGFloat   _acceCount;
    
        CGFloat   _uniformCount;
    
        CGFloat   _decCount;
    
        
    
        
    
        
    
        CGFloat   accFactor;
    
        CGFloat   uniformFactor;
    
        CGFloat   decFactor;
    
        
    
    BOOL      enableRotate;
    
    
    
    CGFloat   acceRadian;
    
    CGFloat   uniformRadian;
    
    CGFloat   decRadian;
    
    
    
    CGFloat   uniformSpeed;
    
    
    
    BOOL      firstAccRotate;
    
    BOOL      firstDecRotate;
    
    
    
    CGFloat   specRadian;    //指定的角度
    
    BOOL      enableSpecRadian;
    
    CGFloat   tinySpecRadian;  //这个角度是相对于最大速度来说的
    
    NSInteger specRoateRepeatCount; //如果指定的角度比最大速度还要大，那么就要拆分成段进行操作。
    
    
      CGFloat   lastTotalRadian;
    
       
    
      CGFloat   lastPassedRadian; //上次走过的弧度
    
       
    
      CGFloat   rotateTransform; //坐标旋转角度
    
       
    
      CGFloat   lastRadianPosition;//最后的位置
    
       
    
      BOOL      enableUniformSpeedRotate;
    
}

//迅速进行

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat) aDuration uniformSpeed:(CGFloat)speed
{
    self = [self initWithView:aLayer Duration:aDuration Animation:YES
                   StopRadian:NoSpecifyStopRadian];
    _acceCount = 0;
    _decCount = 0;
    _uniformCount =CALC_DURATION_COUNT( _duration , 1.0);
    uniformSpeed = speed;
    enableUniformSpeedRotate = YES;
    return self;
}

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat) aDuration
{
    return [self initWithView:aLayer Duration:aDuration Animation:YES StopRadian:NoSpecifyStopRadian];
}

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat)aDuration Animation:(BOOL) enableAnimation StopRadian:(RadianRange) aStopRadian
{
    if(self = [super init]){
        _duration = aDuration;
        _animation = enableAnimation;
        _stopRadian = aStopRadian;
        _layer = aLayer;
        _delegate = nil;
        lastPassedRadian = 0.0;
        lastTotalRadian = 0;
        specRadian = 0.0;
        lastRadianPosition = 0.0;
        timerInterval = DEFAULT_TIMER_INTERVAL;
        _radian = DEFAULT_BEGIN_ROTATE_RADIN;
        _rotatePhase = RotatePhaseAcceleration;
        totalRadian = 0;
        _acceCount = CALC_DURATION_COUNT(_duration , DEFAULT_ACC_PROPORTION);
        _uniformCount =  CALC_DURATION_COUNT( _duration , DEFAULT_UNI_PROPORTION);
        _decCount = CALC_DURATION_COUNT(_duration , DEFAULT_DEC_PROPORTION);
        accFactor = powf(DEFAULT_MAX_ROTATE_RADIAN/DEFAULT_BEGIN_ROTATE_RADIN,1.0f/(_acceCount-1));
        decFactor = powf(DEFAULT_STOP_ROTATE_RADIN/DEFAULT_MAX_ROTATE_RADIAN,1.0f/(_decCount-1));
        enableRotate = YES;
        uniformSpeed = DEFAULT_BEGIN_ROTATE_RADIN* powf(accFactor,_acceCount-1);
        //这里要放到计算指定角度后面，这样才可以计算出真是的总旋转弧度
        acceRadian = SUM_RADIAN(DEFAULT_BEGIN_ROTATE_RADIN,_acceCount,accFactor) ;
        uniformRadian = uniformSpeed * _uniformCount;
        decRadian = SUM_RADIAN(uniformSpeed,_decCount,decFactor);
        rotateTransform = 0.0;
        enableUniformSpeedRotate = NO;
    }
    return self;
}

- (void) stopTimer

{
    
        enableRotate = NO;
    
        if([timer isValid])
        
            {
            
                    [timer invalidate];
            
                    timer = nil;
            
                }
    
}

- (void) setRotateTransform:(CGFloat)radian;

{
    
        radian = GET_MOD_RADIAN(radian);
    
        
    
        
    
        if(radian<0)
        
            {
            
                    radian = A_CIRCLE_RADIAN+ radian;
            
                }
    
        
    
        rotateTransform = radian;
    
}

- (void) _reset{
    _radian = enableUniformSpeedRotate? uniformSpeed: DEFAULT_BEGIN_ROTATE_RADIN;
    _rotatePhase = RotatePhaseAcceleration;
    totalRadian = 0;
    acceCount = _acceCount;
    uniformCount = _uniformCount;
    decCount = _decCount;
    enableRotate = YES;
    enableSpecRadian = NO;
    specRoateRepeatCount = 0;
    tinySpecRadian = 0;
    if(IS_VALID_RADIAN_RANGE(_stopRadian)){
        CGFloat total = acceRadian + uniformRadian + decRadian;
        //需要增加leftTo的角度已实现刚好是2PI的倍数
        CGFloat leftTo = (A_CIRCLE_RADIAN - GET_MOD_RADIAN(total));
        //如果是第一次，那么为0，这里是为了能够连续几次转动之后仍能到指定位置
        CGFloat needRadian = (A_CIRCLE_RADIAN - lastPassedRadian);
        enableSpecRadian = YES;
        int randNum = (rand()%20);
        NSLog(@"randNum:%d,%f",randNum,randNum / 20.0f );
        specRadian = (randNum?randNum:1) / 20.0f * (_stopRadian.endRadian - _stopRadian.startRadian) + _stopRadian.startRadian;
        //NSLog(@"spec:%f",specRadian);
        lastPassedRadian = specRadian;
        specRadian += leftTo;
        specRadian += needRadian;
        specRadian = GET_MOD_RADIAN(specRadian);
        //计算这个角度应该插入到哪个位置进行旋转
        if(specRadian > uniformSpeed){
            specRoateRepeatCount = specRadian / uniformSpeed;
        }
        //将超出的加入到迅速里面
        uniformCount += specRoateRepeatCount;
        tinySpecRadian = specRadian - specRoateRepeatCount * uniformSpeed;
        //acceRadian += tinySpecRadian;
        //uniformRadian = uniformSpeed * uniformCount;
    }
    if(rotateTransform > 0){
        tinySpecRadian += rotateTransform;
        //计算这个角度应该插入到哪个位置进行旋转
        if(tinySpecRadian > uniformSpeed){
            specRoateRepeatCount = tinySpecRadian / uniformSpeed;
        }
        //将超出的加入到迅速里面
        uniformCount += specRoateRepeatCount;
        tinySpecRadian = tinySpecRadian -  specRoateRepeatCount * uniformSpeed;
        rotateTransform = 0.0;
    }
    firstAccRotate = YES;
        firstDecRotate = YES;
}

- (void) setStopRadian:(RadianRange) newRadian

{
    
        if(newRadian.startRadian == _stopRadian.startRadian && newRadian.endRadian == _stopRadian.endRadian)
        
            {
            
                    return;
            
                }
    
        [self stopRotate:NO];
    
        _stopRadian = newRadian;
    
        //[self _reset];
    
}

-(void)pauseLayer:(CALayer*)layer{
    
        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
        layer.speed = 0.0;
    
        layer.timeOffset = pausedTime;
    
}

-(void)resumeLayer:(CALayer*)layer{
    
        CFTimeInterval pausedTime = [layer timeOffset];
    
        layer.speed = 1.0;
    
        layer.timeOffset = 0.0;
    
        layer.beginTime = 0.0;
    
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    
        layer.beginTime = timeSincePause;
    
}

- (void) restRotate

{
    
        [self stopRotate];
    
        [_layer removeAllAnimations];
    
}

-(void) pauseRotate

{
    
        [self pauseLayer:_layer];
    
}

-(void) resumeRotate

{
    
         [self resumeLayer:_layer];
    
}

//开始旋转

- (void) startRotate

{
    
        if([timer isValid])
        
                [self stopRotate:NO];
    
        
    
        enableRotate = YES;
    
        [self _reset];
    
        //timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    
        //[self rotate];
    
        
    
        CAKeyframeAnimation * keyFrameAnimation = [self genKeyframeAnimation:_duration];
    
        [_layer addAnimation:keyFrameAnimation forKey:@"transform.rotation.z"];
    
        
    
}

//停止旋转

- (void) stopRotate

{
    
        [self stopRotate:_animation];
    
}

- (void) stopRotate:(BOOL) enableAnimation

{
    
        if(enableAnimation && [timer isValid])
        
            {
            
                    acceCount =0;
            
                    uniformCount =0;
            
                    decCount *= 0.7;
            
                }
    
        else
        
            {
            
                    [self stopTimer];
            
                }
    
}

- (CAKeyframeAnimation*) genKeyframeAnimation:(CGFloat)duration

{
    
      
    
        CAKeyframeAnimation * rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"]; //设置动画类型为绕z轴旋转（即图片的水平翻转）
    
        rotateAnimation.fillMode = kCAFillModeForwards;
    
        rotateAnimation.calculationMode = kCAAnimationLinear;
    
        
    
        NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:50];
    
        
    
        CGFloat radian = 0.0f;
    
        
    
        CGFloat lastradian = lastRadianPosition;
    
       
    
        while(enableRotate && (radian = [self updateRadian]))
        
            {
            
                    totalRadian += radian;
            
                    lastradian += radian;
            
                    lastTotalRadian = totalRadian;
            
                    [values addObject:@(lastradian)];
            
                }
    
        
    
        lastRadianPosition =  GET_MOD_RADIAN(lastradian);
    
        
    
        rotateAnimation.fillMode = kCAFillModeBoth;
    
        //rotateAnimation.calculationMode = kCAAnimationLinear;
    
        rotateAnimation.values = values;
    
        //设置起始位置，在此为0~2pi，即旋转360度
    
        rotateAnimation.duration = duration; //动画持续时间1秒
    
        //rotateAnimation.keyTimes = keyTime;
    
        rotateAnimation.rotationMode = kCAAnimationRotateAuto;
    
        rotateAnimation.delegate = self;
    
        rotateAnimation.removedOnCompletion = NO;
    
        
    
        return rotateAnimation;
    
}

#pragma mark -

#pragma mark RotatorDelegate Notify

/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim

{
    
        if(_delegate && [_delegate respondsToSelector:@selector(startRotate:)])
        
            {
            
                    [_delegate startRotate:_layer];
            
                }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag

{
    
        [self stopRotate:NO];
    
        
    
        if(_delegate && [_delegate respondsToSelector:@selector(completeRotate:)])
        
            {
            
                    [_delegate completeRotate:_layer];
            
                }
    
}

#pragma mark -

#pragma mark Calc radian

- (CGFloat) updateRadian:(CGFloat)lastRadian

{
    
        if (_animation) {
        
                return lastRadian * [self getSpeedFactor];
        
            }
    
        else{
        
                return uniformRadian;
        
                //return DEFAULT_MAX_ROTATE_RADIAN;
        
            }
    
        
    
        return 0.0;
    
}

- (CGFloat) updateRadian

{
    
        if(enableSpecRadian &&  _radian > tinySpecRadian)
        
            {
            
                    enableSpecRadian = NO;
            
                    return  tinySpecRadian;
            
                }
    
        
    
        if([_delegate respondsToSelector:@selector(updateRadian:)])
        
            {
            
                    _radian = [_delegate updateRadian:_radian];
            
                }
    
        else
        
            {
            
                    _radian = [self updateRadian:_radian];
            
                }
    
        
    
        return _radian;
    
}

+ (RadianRange) calcRadian:(int) index totalSeg:(int)totalCount;

{
    
        //计算停止位置    [startRadian,ednRadian)
    
        RadianRange range;
    
        range.startRadian = CALC_RADIAN(index,totalCount);
    
        range.endRadian = CALC_RADIAN(index+1,totalCount);
    
        return range;
    
}

+ (RadianRange) calcRadian:(int) index totalSeg:(int)totalCount clockwise:(int)clockwise

{
    
        if (clockwise == 0) {
        
                //顺时针
        
                index = totalCount-index-1;
        
                return [Rotator calcRadian:index totalSeg:totalCount];
        
            }
    
        else
        
            {
            
                    return [Rotator calcRadian:index totalSeg:totalCount];
            
                }
    
}

#pragma mark -

#pragma mark Rotate phase

- (RotatePhase) checkRotatePhase

{
    
        if(acceCount-- > 0)
        
            {
            
                    _rotatePhase = RotatePhaseAcceleration;
            
                    goto _ret;
            
                }
    
        
    
        if(uniformCount-- > 0)
        
            {
            
                    _rotatePhase = RoatePhaseUniformSpeed;
            
                    goto _ret;
            
                }
    
        
    
        if(decCount-- > 0)
        
            {
            
                    _rotatePhase = RoatePhaseDecelerations;
            
                    goto _ret;
            
                }
    
        
    
        _rotatePhase = RoatePhaseUnknown;
    
         
    
_ret:
    
        return _rotatePhase;
    
}

- (CGFloat) getSpeedFactor

{
    
        switch ([self checkRotatePhase]) {
            
                    case RotatePhaseAcceleration:
            
                        rotateFactor = firstAccRotate?(firstAccRotate=NO,rotateFactor=DEFAULT_UNIFORM_FACOTR):accFactor;
            
                        break;
            
                    case RoatePhaseUniformSpeed:
            
                        rotateFactor = DEFAULT_UNIFORM_FACOTR;
            
                        break;
            
                    case RoatePhaseDecelerations:
            
                        rotateFactor = firstDecRotate?(firstDecRotate=NO,rotateFactor=DEFAULT_UNIFORM_FACOTR):decFactor;
            
                        break;
            
                    default:
            
                        rotateFactor = 0;
            
                        break;
            
            }
    
        
    
        return  rotateFactor;
    
}

@end
