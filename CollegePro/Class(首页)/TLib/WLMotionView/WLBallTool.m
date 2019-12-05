//
//  WLBallTool.m
//  WLBallView
//
//  Created by administrator on 2017/6/15.
//  Copyright © 2017年 WL. All rights reserved.
//

#import "WLBallTool.h"
#import <CoreMotion/CoreMotion.h>

@interface WLBallTool ()

@property (nonatomic, strong) CMMotionManager * manager;
@property (nonatomic, strong) UIGravityBehavior * gravity;
@property (nonatomic, strong) UIDynamicAnimator * animator;
@property (nonatomic, strong) UICollisionBehavior * collision;
@property (nonatomic, strong) UIDynamicItemBehavior * dynamic;

@end



@implementation WLBallTool

static dispatch_once_t onceToken;

+ (instancetype)shareBallTool {
    
    static WLBallTool * ball;
    
    
    dispatch_once(&onceToken, ^{
       
        ball = [[WLBallTool alloc] init];
        
    });
    
    return ball;
}

- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView {
    
    _referenceView = referenceView;
    
    [self.dynamic addItem:ballView];
    [self.collision addItem:ballView];
    [self.gravity addItem:ballView];
    
    [self run];
}

- (void)run {
    
        if (!self.manager.isDeviceMotionAvailable) {
            NSLog(@"换手机吧");
            return;
        }
        
        self.manager.deviceMotionUpdateInterval = 0.01;
        
        __weak typeof(self) weakSelf = self;
    
        [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            if (error != nil) {
                NSLog(@"出错了 %@",error);
                return;
            }
            weakSelf.gravity.gravityDirection = CGVectorMake(motion.gravity.x * 3, -motion.gravity.y * 3);
            //        self.bkView.transform = CGAffineTransformMakeRotation(atan2(motion.gravity.x, motion.gravity.y) - M_PI);
        }];
        
}
# pragma mark - 停止运动
- (void)stopMotionUpdates {
    
    if (self.manager.isDeviceMotionActive) {
        [self.manager stopDeviceMotionUpdates];
        [self.animator removeAllBehaviors];
        onceToken = 0;
    }
}

# pragma mark - 运动管理者
- (CMMotionManager *)manager {
    
    
    if (_manager == nil) {
        _manager = [[CMMotionManager alloc] init];
    }
    return _manager;
}


# pragma mark - 动态媒介
-  (UIDynamicAnimator *)animator {
    
    if (_animator == nil) {
        // 设置参考边界
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
        
    }
    
    return _animator;
    
}
# pragma mark - 重力
-  (UIGravityBehavior *)gravity {
    
    if (_gravity == nil) {
        
        _gravity = [[UIGravityBehavior alloc] init];
//        _gravity.magnitude = 1.0;
        [self.animator addBehavior:_gravity];
    }
    
    return _gravity;
    
}
# pragma mark - 碰撞
-  (UICollisionBehavior *)collision {
    
    if (_collision == nil) {
        
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        _collision.collisionMode = UICollisionBehaviorModeEverything;
        [self.animator addBehavior:_collision];
    }
    
    return _collision;
    
}
# pragma mark - 动力学属性
-  (UIDynamicItemBehavior *)dynamic {
    
    if (_dynamic == nil) {
        
        _dynamic = [[UIDynamicItemBehavior alloc] init];
        _dynamic.friction = 0.2;
        _dynamic.elasticity = 0.8;
        _dynamic.density = 0.2;
        _dynamic.allowsRotation = YES;
        _dynamic.resistance = 0;
        [self.animator addBehavior:_dynamic];
    }
    
    return _dynamic;
    
}

@end
