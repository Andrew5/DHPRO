//
//  PlayAudio.h
//  PlayAudio
//
//  Created by 杨飞 on 11/1/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	INITIALIZED = 0,
	STARTING_FILE_THREAD,          // 启动线程
	WAITING_FOR_DATA,              // 准备数据
	FLUSHING_EOF,                  // 数据准备完毕
	WAITING_FOR_QUEUE_TO_START,    // 排队播放
	PLAYING,                       // 正在播放
	BUFFERING,                     // 网络不好,自动缓冲
	PAUSED,                        // 手动暂停
	STOPPING,                      // 即将停止,自动提醒
	STOPPED,                       // 已停止播放
} State;

typedef enum
{
	NO_STOP = 0,
	STOPPING_EOF,
	STOPPING_USER_ACTION,
	STOPPING_ERROR,
	STOPPING_TEMPORARILY
} StopReason;

typedef enum
{
	NO_ERROR = 0,
	NETWORK_CONNECTION_FAILED,
	FILE_STREAM_GET_PROPERTY_FAILED,
	FILE_STREAM_SEEK_FAILED,
	FILE_STREAM_PARSE_BYTES_FAILED,
	FILE_STREAM_OPEN_FAILED,
	FILE_STREAM_CLOSE_FAILED,
	AUDIO_DATA_NOT_FOUND,
	AUDIO_QUEUE_CREATION_FAILED,
	AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED,
	AUDIO_QUEUE_ENQUEUE_FAILED,
	AUDIO_QUEUE_ADD_LISTENER_FAILED,
	AUDIO_QUEUE_REMOVE_LISTENER_FAILED,
	AUDIO_QUEUE_START_FAILED,
	AUDIO_QUEUE_PAUSE_FAILED,
	AUDIO_QUEUE_BUFFER_MISMATCH,
	AUDIO_QUEUE_DISPOSE_FAILED,
	AUDIO_QUEUE_STOP_FAILED,
	AUDIO_QUEUE_FLUSH_FAILED,
	AUDIO_STREAMER_FAILED,
	GET_AUDIO_TIME_FAILED,
	AUDIO_BUFFER_TOO_SMALL
} ErrorCode;

@protocol PlayAudio <NSObject>

@property State state;

@optional
- (void)start;
- (void)stop;
- (void)pause;

- (void)seekToTime:(double)newSeekTime;
- (double)calculatedBitRate;
- (float)currentTime;
- (float)duration;

@end
