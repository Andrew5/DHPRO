//
//  PlayLocal.m
//  PlayAudio
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import "PlayLocal.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

static UInt32 gBufferSizeBytes=0x10000;//It muse be pow(2,x)

@interface PlayLocal()

@property (nonatomic,retain) AVAudioPlayer *audioPlayer;

//定义回调(Callback)函数
static void BufferCallack(void *inUserData,AudioQueueRef inAQ,
                          AudioQueueBufferRef buffer);
//定义缓存数据读取方法
-(void)audioQueueOutputWithQueue:(AudioQueueRef)audioQueue
                     queueBuffer:(AudioQueueBufferRef)audioQueueBuffer;
-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer;

@end

@implementation PlayLocal

@synthesize audioPath;
@synthesize audioURL;
@synthesize state;
@synthesize audioPlayer;

- (id)initWithURL:(NSURL *)url error:(NSError **)outError
{
    if (self == [super init])
    {
        if (![url isFileURL])
        {
            url = [NSURL fileURLWithPath:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]];
        }
        audioURL = url;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    
    return self;
}

- (AudioQueueRef)createQueue
{
    UInt32 size,maxPacketSize;
    char *cookie;
    int i;
    OSStatus status;
    
    //打开音频文件
    status = AudioFileOpenURL((__bridge CFURLRef)audioURL, kAudioFileReadPermission, 0, &audioFile);
    if(status != noErr)
    {
        NSLog(@"*** Error *** PlayAudio - Play:Path could not open audio file. Path given was : %@",[audioURL absoluteString]);
        return nil;
    }
    
    for(int i = 0;i < NUM_BUFFERS; i++)
    {
        AudioQueueEnqueueBuffer(audioQueue, buffers[i], 0, nil);
    }
    
    //取得音频数据格式
    size = sizeof(dataFormat);
    AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &size, &dataFormat);
    
    //创建播放用的音频队列
    AudioQueueNewOutput(&dataFormat,BufferCallBack, (__bridge void * _Nullable)(self), nil, nil, 0, &audioQueue);
    //计算单位时间内包含的包数
    if(dataFormat.mBytesPerPacket == 0 || dataFormat.mFramesPerPacket == 0)
    {
        size = sizeof(maxPacketSize);
        AudioFileGetProperty(audioFile, kAudioFilePropertyPacketSizeUpperBound, &size, &maxPacketSize);
        if(maxPacketSize > gBufferSizeBytes)
        {
            maxPacketSize = gBufferSizeBytes;
        }
        //算出单位时间内包含的包数
        numPacketsToRead = gBufferSizeBytes/maxPacketSize;
        packetDescs = malloc(sizeof(AudioStreamPacketDescription)*numPacketsToRead);
    }
    else
    {
        numPacketsToRead = gBufferSizeBytes/dataFormat.mBytesPerPacket;
        packetDescs = nil;
    }
    
    //设置magic cookie
    AudioFileGetProperty(audioFile, kAudioFilePropertyMagicCookieData, &size, nil);
    if(size > 0)
    {
        cookie = malloc(sizeof(char)*size);
        AudioFileGetProperty(audioFile, kAudioFilePropertyMagicCookieData, &size, cookie);
        AudioQueueSetProperty(audioQueue, kAudioQueueProperty_MagicCookie, cookie, size);
    }
    
    //创建并分配缓冲空间
    packetIndex = 0;
    for(i = 0; i < NUM_BUFFERS; i++)
    {
        AudioQueueAllocateBuffer(audioQueue, gBufferSizeBytes, &buffers[i]);
        //读取包数据
        if([self readPacketsIntoBuffer:buffers[i]] == 1)
        {
            break;
        }
    }
    
    return audioQueue;
}

//定义回调(Callback)函数
static void BufferCallBack(void *inUserData,AudioQueueRef inAQ,
                          AudioQueueBufferRef buffer)
{
    PlayLocal *player = (__bridge PlayLocal*)inUserData;
    [player audioQueueOutputWithQueue:inAQ queueBuffer:buffer];
}

//定义缓存数据读取方法
-(void)audioQueueOutputWithQueue:(AudioQueueRef)queue
                     queueBuffer:(AudioQueueBufferRef)queueBuffer
{
    OSStatus status;
    
    //读取包数据
    UInt32 numBytes;
    UInt32 numPackets=numPacketsToRead;
    status = AudioFileReadPackets(audioFile, NO, &numBytes, packetDescs, packetIndex,&numPackets, queueBuffer->mAudioData);
    
    //成功读取时
    if (numPackets>0) {
        //将缓冲的容量设置为与读取的音频数据一样大小(确保内存空间)
        queueBuffer->mAudioDataByteSize=numBytes;
        //完成给队列配置缓存的处理
        status = AudioQueueEnqueueBuffer(queue, queueBuffer, numPackets, packetDescs);
        //移动包的位置
        packetIndex += numPackets;
    }
}

-(UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer
{
    UInt32 numBytes,numPackets;
    //从文件中接受数据并保存到缓存(buffer)中
    numPackets = numPacketsToRead;
    AudioFileReadPackets(audioFile, NO, &numBytes, packetDescs, packetIndex, &numPackets, buffer->mAudioData);
    if(numPackets >0){
        buffer->mAudioDataByteSize=numBytes;
        AudioQueueEnqueueBuffer(audioQueue, buffer, (packetDescs ? numPackets : 0), packetDescs);
        packetIndex += numPackets;
    }
    else{
        return 1;//意味着我们没有读到任何的包
    }
    return 0;//0代表正常的退出
}

- (void)start
{
    @synchronized(self)
    {
        if (state == PAUSED) {
            [self pause];
        }
        else if (state == INITIALIZED) {
            if ([self createQueue])
            {
                Float32 gain = 1.0;
                AudioQueueSetParameter(audioQueue, kAudioQueueParam_Volume, gain);
                AudioQueueStart(audioQueue, nil);
                state = PLAYING;
            }
            else
            {
                NSLog(@"create queue failed");
            }
        }
        else if(state == PLAYING)
        {
            //do nothing
        }
    }
}

- (void)pause
{
    @synchronized(self)
	{
		if (state == PLAYING)
		{
			err = AudioQueuePause(audioQueue);
			if (err)
			{
                NSLog(@"err:%s","AUDIO_QUEUE_PAUSE_FAILED");
				return;
			}
			self.state = PAUSED;
		}
		else if (state == PAUSED)
		{
			err = AudioQueueStart(audioQueue, NULL);
			if (err)
			{
                NSLog(@"err:%s","AUDIO_QUEUE_START_FAILED");
				return;
			}
			self.state = PLAYING;
		}
	}
}

- (void)setState:(State)aStatus
{
	@synchronized(self)
	{
		if (state != aStatus)
		{
			state = aStatus;
		}
	}
}

- (State)state
{
    return state;
}

- (void)stop
{
    @synchronized(self)
	{
		
        if (audioQueue && (state == PLAYING || state == PAUSED))
		{
			self.state = STOPPING;
			stopReason = STOPPING_USER_ACTION;
			err = AudioQueueStop(audioQueue, true);
			if (err)
			{
                NSLog(@"err:%s","AUDIO_QUEUE_STOP_FAILED");
				return;
			}
		}
		else if (state != INITIALIZED)
		{
			self.state = STOPPED;
			stopReason = STOPPING_USER_ACTION;
		}
		seekWasRequested = NO;
	}
}

//本地的暂时没有
- (void)seekToTime:(double)newSeekTime
{
    @synchronized(self)
    {
        // Negative values skip to start of file
        if (newSeekTime<0.0f)
            newSeekTime = 0.0f;
        
        // Rounds down to remove sub-second precision
        newSeekTime = (int)newSeekTime;
        
        // Prevent skipping past end of file
        if(newSeekTime >= (int)audioPlayer.duration)
        {
            NSLog( @"Audio: IGNORING skip to <%.02f> (past EOF) of <%.02f> seconds", newSeekTime, audioPlayer.duration );
            return;
        }
       
        NSLog( @"Audio: skip to <%.02f> of <%.02f> seconds", newSeekTime, audioPlayer.duration );
        
        // NOTE: This stop,set,prepare,(play) sequence produces reliable results on the simulator and device.
        [audioPlayer stop];
        [audioPlayer setCurrentTime:newSeekTime];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
}

- (float)currentTime
{
    if (!audioPlayer) {
        float currentTime = audioPlayer.currentTime;
        return currentTime;
    }
    
    return 0.0;
}

- (float)duration
{
    if (!audioPlayer) {
        float duration = self.audioPlayer.duration;
        return duration;
    }
    
    return 0.0;
}

- (double)calculatedBitRate
{
    return 0.0;
}


@end
