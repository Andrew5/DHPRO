#import "LHCacheTool.h"
#import "LHMD5.h"

@implementation LHCacheTool


+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    NSString *path = [LHCachePath stringByAppendingPathComponent:[LHMD5 md5:fileName]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:path atomically:YES];
    });
}

+ (NSData *)getCacheFileName:(NSString *)fileName
{
    NSString *path = [LHCachePath stringByAppendingPathComponent:[LHMD5 md5:fileName]];
    return [[NSData alloc] initWithContentsOfFile:path];
}

+ (NSUInteger)getAFNSize
{
    NSUInteger size = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:LHCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [LHCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (NSUInteger)getSize
{
    //获取AFN的缓存大小
    NSUInteger afnSize = [self getAFNSize];
    return afnSize;
}

+ (void)clearAFNCache
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:LHCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [LHCachePath stringByAppendingPathComponent:fileName];
        
        [fm removeItemAtPath:filePath error:nil];
        
    }
}

+ (void)clearCache
{
    [self clearAFNCache];
}

+ (BOOL)isExpire:(NSString *)fileName
{
    NSString *path = [LHCachePath stringByAppendingPathComponent:[LHMD5 md5:fileName]];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:path error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>(3600*24));
}

@end
