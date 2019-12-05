//
//  FIR.h
//  FIRSDK
//
//  Created by Travis on 14-9-28.
//  Copyright (c) 2014年 Fly It Remotely International Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FIRConstants.h"


@interface FIR:NSObject

/* 开始捕获崩溃
 @param crashKey 在 BugHD.com 获得的应用 generalKey
 */
+(void) handleCrashWithKey:(NSString*)crashKey;

/* 手动上传crash,适用于用户try、catch未发生崩溃的情况
 @param exception,捕获到的异常
 */
+(void)sendCrashManually:(NSException *)exception;

/* 设置自定义参数
 @param value NSString型value
 @param key   NSString型key
 
 @Discussion 自定义参数,每次crash发送
 */
+(void)setCustomizeValue:(NSString *)value forKey:(NSString *)key;

/* 根据key删除参数
 @param key   NSString型key
 */
+(void)removeCustomizeValueForKey:(NSString *)key;

/* 清空自定义参数
 */
+(void)removeCustomizeValue;

@end

