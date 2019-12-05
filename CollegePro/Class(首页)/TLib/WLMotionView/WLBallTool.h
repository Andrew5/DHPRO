//
//  WLBallTool.h
//  WLBallView
//
//  Created by administrator on 2017/6/15.
//  Copyright © 2017年 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBallTool : NSObject

@property (nonatomic, weak) UIView * referenceView;

+ (instancetype)shareBallTool;

- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView;

- (void)stopMotionUpdates;

@end
