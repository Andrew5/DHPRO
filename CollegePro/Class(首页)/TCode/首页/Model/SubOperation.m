//
//  SubOperation.m
//  TableViewAnimationKit-OC
//
//  Created by jabraknight on 2020/4/6.
//  Copyright © 2020 com.cn.fql. All rights reserved.
//

#import "SubOperation.h"

@implementation SubOperation
-(instancetype)init {
    if (self =[super init]) {
        self.state = AFOperationReadyState;
    }
    return  self;
}

-(void)start {
    int index = 0 ;
    while (index < 5) {
        self.state = AFOperationExecutingState ;
        sleep(1);
        index += 1;
    }
    
    self.state = AFOperationFinishedState;
}
- (BOOL)isReady {
    return self.state == AFOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == AFOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == AFOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}
@end
