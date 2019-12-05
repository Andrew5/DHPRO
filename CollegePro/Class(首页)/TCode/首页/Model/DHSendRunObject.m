//
//  DHSendRunObject.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/29.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHSendRunObject.h"

@implementation DHSendRunObject
-(void)sendEvent:(UIEvent *)event{
    
    [super sendEvent:event];
    
    if (!self.Timer) {
        
        [self resetTimer];
        
    }
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count]>0) {
        
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        
        if (phase == UITouchPhaseBegan) {
            
            [self resetTimer];
            NSLog(@"重启计时器");
            
        }
        
    }
    
}
-(void)resetTimer{
    
    if (self.Timer) {
        
        [self.Timer invalidate];
        
    }
    
    self.Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(notifyToAction) userInfo:nil repeats:NO];
    
}
-(void)notifyToAction{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ActionD" object:nil];
    
}
@end
