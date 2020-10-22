//
//  AudioEdit.m
//  CollegePro
//
//  Created by admin on 2020/9/11.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "AudioEdit.h"

@implementation AudioEdit
+ (instancetype)shareAudioEdit{
    static AudioEdit *audioEdit;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        audioEdit = [[AudioEdit alloc] init];
    });
    return audioEdit;
}
// 支持音频:m4a  视频:mp4
- (void)exportPath:(NSString *)exportPath
      withFilePath:(NSString *)filePath
     withStartTime:(int64_t)startTime
       withEndTime:(int64_t)endTime
         withBlock:(success)handle{
    __weak typeof(self) weakSelf=self;
    _block = handle;
    NSString *presetName;
    NSString *outputFileType;
    if ([filePath.lastPathComponent containsString:@"mp4"]) {
        presetName = AVAssetExportPreset1280x720;
        outputFileType = AVFileTypeMPEG4;
    }else if ([filePath.lastPathComponent containsString:@"m4a"]){
        presetName = AVAssetExportPresetAppleM4A;
        outputFileType = AVFileTypeAppleM4A;
    }else{
        _block(NO);
        return;
    }
    // 1.拿到预处理音频文件
    NSURL *songURL = [NSURL fileURLWithPath:filePath];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
    // 2.创建新的音频文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    NSError *assetError;
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL fileType:AVFileTypeCoreAudioFormat error:&assetError];
    if (assetError) {
        NSLog (@"创建文件失败 error: %@", assetError);
        _block(NO);
    }
    // 3.创建音频输出会话
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:songAsset presetName:presetName];
    CMTime _startTime = CMTimeMake(startTime, 1);
    CMTime _stopTime = CMTimeMake(endTime, 1);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(_startTime, _stopTime);
    // 4.设置音频输出会话并执行
    exportSession.outputURL = [NSURL fileURLWithPath:exportPath]; // output path
    exportSession.outputFileType = outputFileType;            // output file type AVFileTypeAppleM4A
    exportSession.timeRange = exportTimeRange;                    // trim time range
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusCompleted");
            [[NSFileManager defaultManager] replaceItemAtURL:[NSURL URLWithString:filePath] withItemAtURL:[NSURL URLWithString:exportPath] backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:nil];
            weakSelf.block(YES);
        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
            NSLog(@"AVAssetExportSessionStatusFailed");
            weakSelf.block(NO);
        } else {
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
            weakSelf.block(NO);
        }
    }];
}


@end
