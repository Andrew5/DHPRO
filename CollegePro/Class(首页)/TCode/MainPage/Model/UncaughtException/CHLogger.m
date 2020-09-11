//
//  CHLogger.m
//  CollegePro
//
//  Created by admin on 2019/10/19.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CHLogger.h"

#define LOG_TIME_FORMAT @"yyyy-MM-dd HH:mm:ss.SSS"
 
#define LOG_QUEUE_ID "log_queue"
static CHLogger *_instance=nil;
static dispatch_queue_t queue_log;
//static NSUncaughtExceptionHandler *_handler;

@implementation CHLogger
+(CHLogger *)shareInstance
{
    @synchronized(self)
    {
        if(_instance==nil)
        {
            _instance=[[self alloc]init];
            
            queue_log = dispatch_queue_create(LOG_QUEUE_ID, DISPATCH_QUEUE_SERIAL);
        }
        
    }
    return _instance;
}
#pragma mark -设置crash
+ (void)setDefaultUncaughtExceptionHandler
{
 
    NSSetUncaughtExceptionHandler (&chUncaughtExceptionHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
    
}
 
#pragma mark -获取崩溃日志
void chUncaughtExceptionHandler(NSException *exception)
{
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:LOG_TIME_FORMAT];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSString *exceptionInfo = [NSString stringWithFormat:@"%@Exception reason：%@\nException name：%@\nException stack：%@", time, name, reason, stackArray];
    NSLog(@"exceptionInfo %@",exceptionInfo);
//    [self writeLogfile:exceptionInfo fileName:LOG_CRASH];
 
}
 
void SignalHandler(int signal)
{
    //拦截signal
}
 
-(void)debug:(NSString *)format,...
{
   
//    if(self._logLevel < LOG_LEVEL_DEBUG)
//    {
//        return ;
//    }
    if (format != NULL)
    {
        @try {
            CFStringRef param = (__bridge CFStringRef)format;
            va_list args;
            va_start(args, format);
            CFStringRef s = CFStringCreateWithFormatAndArguments(NULL, NULL, param, args);
            va_end(args);
            if (s != NULL)
            {
                NSString *msg = [NSString stringWithFormat:@"%@\n", (__bridge NSString *)s];
              
                [self printMsg:[self formatLogMsg:msg]];
            }
 
        } @catch (NSException *exception) {
          
        }
        
    }
}
 
-(NSString *)formatLogMsg:(NSString *)formatText
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:LOG_TIME_FORMAT];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    NSMutableString *msg = [NSMutableString stringWithFormat:@"%@ ", time];
    [msg appendString:formatText];
    
    return msg;
}
 
-(void)info:(NSString *)format,...
{
 
//    if(self._logLevel < LOG_LEVEL_INFO)
//    {
//        return ;
//    }
    if (format != NULL)
    {
        @try {
            CFStringRef param = (__bridge CFStringRef)format;
            va_list args;
            va_start(args, format);
            CFStringRef s = CFStringCreateWithFormatAndArguments(NULL, NULL, param, args);
            va_end(args);
            if (s != NULL)
            {
                NSString *msg = [NSString stringWithFormat:@"%@\n", (__bridge NSString *)s];
               
                [self printMsg:[self formatLogMsg:msg]];
            }
 
        } @catch (NSException *exception) {
           
        }
    }
}
 
-(void)error:(NSString *)format,...
{
   
//    if(self.logLevel < LOG_LEVEL_ERROR)
//    {
//        return ;
//    }
    if (format != NULL)
    {
        @try {
            CFStringRef param = (__bridge CFStringRef)format;
            va_list args;
            va_start(args, format);
            CFStringRef s = CFStringCreateWithFormatAndArguments(NULL, NULL, param, args);
            va_end(args);
            if (s != NULL)
            {
                NSString *msg = [NSString stringWithFormat:@"%@\n", (__bridge NSString *)s];
              
                [self printMsg:[self formatLogMsg:msg]];
            }
 
        } @catch (NSException *exception) {
           
        }
    }
}
 

 
-(void)printMsg:(NSString *)msg
{
    dispatch_async(queue_log, ^{
        NSLog(@"输出queue_log %@",msg);
        [CHLogger writeLogfile:msg fileName:@"输出queue_log"];
    });
}
#pragma mark -输出日志
+ (void)writeLogfile:(NSString *)msg fileName:(NSString *)fileName
{
    @try
    {
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * homePath = [path stringByAppendingPathComponent:@"testException"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:homePath])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
        {
            //创建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
 
        NSString *filePath = [homePath stringByAppendingPathComponent:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        {
            [msg writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
        
        NSData* stringData  = [msg dataUsingEncoding:NSUTF8StringEncoding];
        
        [fileHandle writeData:stringData]; //追加写入数据
        
        [fileHandle closeFile];
    }
    @catch(NSException *e)
    {
 
    }
}
- (void)uploadLogFile:(NSString *)taskId logDate:(NSString *)logDate logType:(NSString *)logType{
    
}

@end
