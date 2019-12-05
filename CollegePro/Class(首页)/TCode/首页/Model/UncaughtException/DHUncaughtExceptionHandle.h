//
//  DHUncaughtExceptionHandle.h
//  CollegePro
//
//  Created by jabraknight on 2019/10/14.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHUncaughtExceptionHandle : NSObject
@property (nonatomic,assign)BOOL ismissed;
+ (void)installUncaughtSingalExceptionHandle;
@end

NS_ASSUME_NONNULL_END
