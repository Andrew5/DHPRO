//
//  DHUncaughtExceptionHandle.m
//  CollegePro
//
//  Created by jabraknight on 2019/10/14.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHUncaughtExceptionHandle.h"
#import <sys/time.h>

NSString *const DHUncaughtExceptionHandleAddressKey = @"DHUncaughtExceptionHandleAddressKey";
NSString *const DHUncaughtExceptionHandleFileKey = @"DHUncaughtExceptionHandleFileKey";
NSString *const DHUncaughtExceptionHandleCallStackSymbolsKey = @"DHUncaughtExceptionHandleCallStackSymbolsKey";

@implementation DHUncaughtExceptionHandle
+ (void)installUncaughtSingalExceptionHandle
{
    
}
@end
