//
//  TempTarget.m
//  CollegePro
//
//  Created by jabraknight on 2020/3/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "TempTarget.h"

@implementation TempTarget

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)tempTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    TempTarget *target = [[TempTarget alloc] init];
    target.tempTarget = tempTarget;
    target.selector = selector;
    target.tempTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:target selector:@selector(timerSelector:) userInfo:userInfo repeats:repeats];
    return target.tempTimer;
}

- (void)timerSelector:(NSTimer *)tempTimer {
    if (self.tempTarget && [self.tempTarget respondsToSelector:self.selector]) {
        [self.tempTarget performSelector:self.selector withObject:tempTimer.userInfo];
    }else {
        [self.tempTimer invalidate];
    }
}
@end
