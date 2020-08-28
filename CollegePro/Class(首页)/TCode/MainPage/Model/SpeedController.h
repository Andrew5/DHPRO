//
//  SpeedController.h
//  JHLivePlayLibrary
//
//  Created by xianjunwang on 2017/12/8.
//  Copyright © 2017年 pk. All rights reserved.
//  测速抽象类

#import <Foundation/Foundation.h>

@interface SpeedController : NSObject
+(SpeedController *)sharedManager;
//获取信号强度(0到1)
+(void)getSignalStrength:(void(^)(float signalStrength))resultBlock;
//获取下行速度,上行速度（单位是 MB/S）
-(void)getDownstreamSpeedAndUpstreamSpeed:(void(^)(float downstreamSpeed,float upstreamSpeed))resultBlock;
//停止测速
-(void)stop;
@end
