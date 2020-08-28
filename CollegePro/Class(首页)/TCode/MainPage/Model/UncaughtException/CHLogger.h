//
//  CHLogger.h
//  CollegePro
//
//  Created by admin on 2019/10/19.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHLogger : NSObject
+(CHLogger *)shareInstance;
 
+ (void)setDefaultUncaughtExceptionHandler;
 
-(void)error:(NSString *)format,...;
 
-(void)info:(NSString *)format,...;
 
-(void)debug:(NSString *)format,...;
#pragma mark -捕捉崩溃日志
void chUncaughtExceptionHandler(NSException *exception);
#pragma mark -signal处理
void SignalHandler(int signal);
 
#pragma mark -上传日志文件
-(void)uploadLogFile:(NSString *)taskId logDate:(NSString *)logDate logType:(NSString *)logType;

@end

NS_ASSUME_NONNULL_END
