//
//  NSTimer+UnretainCycle.m
//  CollegePro
//
//  Created by jabraknight on 2020/3/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "NSTimer+UnretainCycle.h"

@implementation NSTimer (UnretainCycle)
+ (NSTimer *)lhScheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                      repeats:(BOOL)repeats
                                        block:(void(^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(blcokInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)blcokInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}
@end
