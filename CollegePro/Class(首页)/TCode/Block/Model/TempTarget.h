//
//  TempTarget.h
//  CollegePro
//
//  Created by jabraknight on 2020/3/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TempTarget : NSObject
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSTimer *tempTimer;
@property (nonatomic, weak) id tempTarget;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)tempTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
