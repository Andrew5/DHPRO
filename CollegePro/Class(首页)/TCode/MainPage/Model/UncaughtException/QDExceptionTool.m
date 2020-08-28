//
//  QDExceptionTool.m
//  UncaughtExceptionHandler
//
//  Created by jabraknight on 19/9/20.
//  Copyright © 2019年 Cocoa with Love. All rights reserved.
//

#import "QDExceptionTool.h"

static id _instance;

@implementation QDExceptionTool
+ (instancetype)shareExceptionTool{
    
    return [[self alloc]init];
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [super allocWithZone:zone];
        
    });
    
    return _instance;
}

+ (void)saveCreash:(NSString *)exceptionInfo
{
    NSString * _libPath  = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SigCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    
    NSString * savePath = [_libPath stringByAppendingFormat:@"/error%@.log",timeString];
    
    BOOL sucess = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES sucess:%d",sucess);
}

- (void)storeExceptionWithExceptionDictionary:(NSDictionary *)dictionary{
    
    
    //不存在就创建
    NSMutableArray *resultArr = [self getExceptionArray];
    
    if (!resultArr)
    {
        resultArr = [NSMutableArray array];
    }
    [resultArr addObject:dictionary];
    
    NSString *docPath = [self getDocumentsPath];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"exception.plist"];
    [resultArr writeToFile:filePath atomically:YES];
    
}

- (void)deleteException{
    
    NSString *documentsPath =[self getDocumentsPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"exception.plist"];
    BOOL isSuccess = [fileManager removeItemAtPath:iOSPath error:nil];
    
    if (isSuccess) {
        NSLog(@"delete success");
    }else{
        NSLog(@"delete fail");
    }

}

- (NSMutableArray *)getExceptionArray{
    
    NSString *docPath = [self getDocumentsPath];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"exception.plist"];
    
    // 从文件中读取数据数组的方法
    NSMutableArray *resultArr = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    return resultArr;
}


- (NSString *)getDocumentsPath
{
    //获取Documents路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path:%@", path);
    return path;
}

@end
