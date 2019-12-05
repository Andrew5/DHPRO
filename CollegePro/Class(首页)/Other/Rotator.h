//
//  Rotator.h
//  15
//
//  Created by jabraknight on 2018/11/13.
//  Copyright © 2018 大爷公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define RADIANS_TO_DEGREES(d) ((d) * 180.0f /M_PI)

#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180.0f)

#define CALC_RADIAN(_index,_total) (2.0f*M_PI*(_index)/((_total)*1.0f))

@protocol RotatorDelegate <NSObject>

@optional

- (CGFloat) updateRadian:(CGFloat)lastRadian;

- (void) startRotate:(CALayer*)layer;

- (void) completeRotate:(CALayer*)layer;

@end

typedef enum

{
    
        RoatePhaseUnknown,
    
        RotatePhaseAcceleration,
    
        RoatePhaseUniformSpeed,
    
        RoatePhaseDecelerations
    
}RotatePhase ;

typedef struct

{
    
        CGFloat startRadian;
    
        CGFloat endRadian;
    
}RadianRange;

#define IS_VALID_RADIAN_RANGE(_range) (_range.startRadian != _range.endRadian)

NS_ASSUME_NONNULL_BEGIN

@interface Rotator : NSObject

//是否缓慢停止

@property (nonatomic,assign) BOOL animation;

//停止的弧度

@property (nonatomic,assign,setter = setStopRadian:) RadianRange stopRadian;

//旋转持续时间

@property (nonatomic,readonly) CGFloat duration;

//要操作的view

@property (nonatomic,retain) CALayer *  layer;

//当前需要转动的角度

@property(nonatomic,readonly) CGFloat radian;

//弧度计算代理器

@property(nonatomic,weak) id<RotatorDelegate> delegate;

//当前旋转阶段

@property(nonatomic,readonly) RotatePhase rotatePhase;

//

//@property(nonatomic,copy) rotate_complete_block completeBlock;

//

//@property(nonatomic,weak) id target;

//@property(nonatomic,assign) SEL eventSel;

//迅速进行

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat) aDuration uniformSpeed:(CGFloat)speed;

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat) aDuration;

- (id) initWithView:(CALayer*) aLayer Duration:(CGFloat)aDuration  Animation:(BOOL) enableAnimation StopRadian:(RadianRange) aStopRadian;

//开始旋转

- (void) startRotate;

//停止旋转

- (void) stopRotate;

- (void) stopRotate:(BOOL) enableAnimation;

- (void) restRotate;

- (void) pauseRotate;

- (void) resumeRotate;

- (void) setStopRadian:(RadianRange) newRadian;

/* 负数表示顺时针转动
 
  */

- (void) setRotateTransform:(CGFloat)radian;

//- (void) addTarget:(id)target selector:(SEL)sel;

+ (RadianRange) calcRadian:(int) index totalSeg:(int)totalCount;

/*
 
  index 从0开始
 
  totalCount 总数
 
  clockwise 0, 顺时针
 
  */

+ (RadianRange) calcRadian:(int) index totalSeg:(int)totalCount clockwise:(int)clockwise;

@end


NS_ASSUME_NONNULL_END
