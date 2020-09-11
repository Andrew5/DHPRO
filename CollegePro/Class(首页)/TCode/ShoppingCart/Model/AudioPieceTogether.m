//
//  AudioPieceTogether.m
//  CollegePro
//
//  Created by admin on 2020/9/11.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "AudioPieceTogether.h"
#define KFILESIZE (1 * 1024 * 1024)


@implementation AudioPieceTogether
- (BOOL)pieceFileA:(NSString *)filePathA
         withFileB:(NSString *)filePathB {
    // 更新的方式读取文件A
    NSFileHandle *handleA = [NSFileHandle fileHandleForUpdatingAtPath:filePathA];
    [handleA seekToEndOfFile];
    NSDictionary *fileBDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathB error:nil];
    long long fileSizeB    = fileBDic.fileSize;
    // 大于xM分片拼接xM
    if (fileSizeB > KFILESIZE) {
        // 分片
       long long pieces = fileSizeB /KFILESIZE;   // 整片
       long long let    = fileSizeB %KFILESIZE;   // 剩余片
       long long sizes = pieces;
        // 有余数
        if (let > 0) {
            // 加多一片
            sizes += 1;
        }
        NSFileHandle *handleB = [NSFileHandle fileHandleForReadingAtPath:filePathB];
        for (int i =0; i < sizes; i++) {
            [handleB seekToFileOffset:i * KFILESIZE];
            NSData *tmp = [handleB readDataOfLength:KFILESIZE];
            [handleA writeData:tmp];
        }
        [handleB synchronizeFile];
    // 大于xM分片读xM(最后一片可能小于xM)
    }else{
        [handleA writeData:[NSData dataWithContentsOfFile:filePathB]];
    }
    [handleA synchronizeFile];
    // 将B文件删除
    [[NSFileManager defaultManager] removeItemAtPath:filePathB error:nil];
    return YES;
}
@end
