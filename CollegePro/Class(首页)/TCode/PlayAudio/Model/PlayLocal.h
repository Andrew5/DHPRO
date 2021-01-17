//
//  PlayLocal.h
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolBox/AudioToolBox.h"
#import "PlayAudio.h"

#define NUM_BUFFERS 3

@interface PlayLocal: NSObject <PlayAudio>
{
    //音频队列
    AudioQueueRef audioQueue;
    //播放音频文件ID
    AudioFileID audioFile;
    //音频流描述对象
    AudioStreamBasicDescription dataFormat;
    
    OSStatus err;
    BOOL seekWasRequested;//判断当前是否允许改变进度
    
    ErrorCode errorCode;
    StopReason stopReason;

    SInt64 packetIndex;
    UInt32 numPacketsToRead;
    UInt32 bufferByteSize;
    AudioStreamPacketDescription *packetDescs;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
}

@property (assign) NSString *audioPath;
@property (assign) NSURL *audioURL;
@property (readwrite) State state;

- (id)initWithURL:(NSURL *)url error:(NSError **)outError;

@end
