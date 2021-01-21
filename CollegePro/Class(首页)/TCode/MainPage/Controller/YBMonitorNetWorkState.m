//
//  YBMonitorNetWorkState.m
//  YBMonitorNetWorkState
//
//  Created by hxcj on 16/5/19.
//  Copyright © 2016年 hxcj. All rights reserved.
//

#import "YBMonitorNetWorkState.h"
@implementation YBMonitorNetWorkState

// 实例化单例对象
+ (YBMonitorNetWorkState *)shareMonitorNetWorkState{
    
    static YBMonitorNetWorkState *shareObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[YBMonitorNetWorkState alloc] init];
    });
    
    return shareObj;
}

// 获取当前网络类型
- (NSString *)getCurrentNetWorkType{
    NSString *netWorkType = @"0";
    // 1.检测wifi状态
    DHReachability *wifi = [DHReachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    DHReachability *conn = [DHReachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {
        // 有wifi
        netWorkType = @"土豪";
    } else if ([conn currentReachabilityStatus] != NotReachable) {
        // 没有使用wifi, 使用手机自带网络进行上网
        netWorkType = @"GPRS";
    } else {
        // 没有网络
        netWorkType = @"noconnect";
    }
    return netWorkType;
}

// 添加网络监听
- (void)addMonitorNetWorkState{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:@"kDHNetworkReachabilityChangedNotification" object:nil];
    self.conn = [DHReachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}

// 触发时机，网络状态发生改变
- (void)netWorkStateChanged{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkStateChanged)]) {
        
        [self.delegate netWorkStateChanged];
    }
}

/**
 * 获取网络状态
 * YES 有网络
 * NO  无网络
 */
- (BOOL)getNetWorkState{
    
    DHReachability *wifi = [DHReachability reachabilityForLocalWiFi];
    DHReachability *conn = [DHReachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }else if([conn currentReachabilityStatus] != NotReachable) {
        
        return YES;
    }else{
        
        return NO;
    }
}


@end
