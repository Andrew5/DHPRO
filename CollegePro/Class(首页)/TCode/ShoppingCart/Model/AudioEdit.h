//
//  AudioEdit.h
//  CollegePro
//
//  Created by admin on 2020/9/11.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h> //媒体库
typedef void(^success)(BOOL ret);
NS_ASSUME_NONNULL_BEGIN

@interface AudioEdit : NSObject
@property (nonatomic, copy)success block;
+ (instancetype)shareAudioEdit;
// 支持音频:m4a  视频:mp4
- (void)exportPath:(NSString *)exportPath
      withFilePath:(NSString *)filePath
     withStartTime:(CMTimeValue)startTime
       withEndTime:(CMTimeValue)endTime
         withBlock:(success)handle;
@end

NS_ASSUME_NONNULL_END
