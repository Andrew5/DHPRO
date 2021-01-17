//
//  AudioTrim.m
//  PlayAudio
//
//  Created by 杨飞 on 10/31/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import "AudioTrim.h"
#import "AVFoundation/AVFoundation.h"

#define FADE_TIME_RANGE 5.0

@interface AudioTrim()
{
    CMTime _startTime;
    CMTime _endTime;
    Float64 _duration;
}
@end

@implementation AudioTrim

- (BOOL)trimAudio:(NSString *)audioPath toFilePath:(NSString *)filePath startTime:(CMTime)startTime stopTime:(CMTime)stopTime
{
    _startTime = startTime;
    _endTime = stopTime;
    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    CMTime assetTime = [avAsset duration];

    _duration = CMTimeGetSeconds(assetTime);
    
    if (CMTimeGetSeconds(startTime) < 0.0 || CMTimeGetSeconds(stopTime) > _duration)
    {
        return NO;
    }

    NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];
    if ([tracks count] == 0)
    {
        return NO;
    }
    
    AVAssetTrack *track = [tracks objectAtIndex:0];

    // 创建输出线程
    AVAssetExportSession *exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:avAsset
                                           presetName:AVAssetExportPresetAppleM4A];
    if (nil == exportSession)
    {
        return NO;
    }
    
    // 剪切区间
    CMTimeRange trimTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    // 创建音频淡入范围
    CMTimeRange fadeInTimeRange = [self fadeInTimeRange];
    CMTimeRange fadeOutTimeRange = [self fadeOutTimeRange];
    
    // 启动音频合成
    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
    AVMutableAudioMixInputParameters *exportAudioMixInputParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    

    [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0 timeRange:fadeInTimeRange];
    [exportAudioMixInputParameters setVolumeRampFromStartVolume:1.0 toEndVolume:0.0 timeRange:fadeOutTimeRange];
    exportAudioMix.inputParameters = [NSArray arrayWithObject:exportAudioMixInputParameters];
    // 配置输出信息
//    NSURL *exportUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"export.m4a"]];
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = trimTimeRange; 
    exportSession.audioMix = exportAudioMix;
    
    // 输出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (AVAssetExportSessionStatusCompleted == exportSession.status)
        {
            NSLog(@"AVAssetExportSessionStatusCompleted");
        }
        else if (AVAssetExportSessionStatusFailed == exportSession.status)
        {
            NSLog(@"AVAssetExportSessionStatusFailed");
        }
        else
        {
            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
        }
    }];
    
    return YES;
}

//  声音开始淡入
- (CMTimeRange)fadeInTimeRange
{
    CMTimeRange fadeInTimeRange;
    Float64 startTimeSecond = CMTimeGetSeconds(_startTime);
    if ((startTimeSecond + FADE_TIME_RANGE) > _duration || (startTimeSecond + FADE_TIME_RANGE) > CMTimeGetSeconds(_endTime))
    {
        return fadeInTimeRange;
    }
    CMTime startFadeInTime = CMTimeMake(startTimeSecond - 1, 1);
    CMTime endFadeInTime = CMTimeMake(startTimeSecond + FADE_TIME_RANGE,1);
    fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime, endFadeInTime);
    
    return fadeInTimeRange;
}

//  声音结束淡出
- (CMTimeRange)fadeOutTimeRange
{
    CMTimeRange fadeOutTimeRange;
    Float64 endTimeSecond = CMTimeGetSeconds(_endTime);
    if ((endTimeSecond - FADE_TIME_RANGE) <= CMTimeGetSeconds(_startTime))
    {
        return fadeOutTimeRange;
    }
    
    CMTime startFadeOutTime = CMTimeMake(endTimeSecond - FADE_TIME_RANGE, 1);
    CMTime endFadeOutTime = _endTime;
    fadeOutTimeRange = CMTimeRangeFromTimeToTime(startFadeOutTime, endFadeOutTime);
    
    return fadeOutTimeRange;
}

@end
