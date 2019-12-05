//
//  AppDelegate.h
//  CollegePro
//
//  Created by jabraknight on 2019/4/30.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign)BOOL allowRotate;

@property(nonatomic,strong) NSTimer * timer;  //定时器// 循环请求计数，后台开启，前台关闭。
@property(nonatomic,strong) AVAudioPlayer * player;
@property(nonatomic,assign) NSInteger number;// Demo自加参数
//闹铃
@property(nonatomic,strong) NSTimer * timer_alarm;  //定时器
@property(nonatomic,assign) NSInteger number_alarm;//时间计时

@property(nonatomic,assign) NSInteger count;

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;


@property (strong, nonatomic) UIWindow *window;

#if kUseScreenShotGesture
@property (strong, nonatomic) ScreenShotView *screenshotView;
#endif
+ (void)playSound:(int)soundID;

@end

