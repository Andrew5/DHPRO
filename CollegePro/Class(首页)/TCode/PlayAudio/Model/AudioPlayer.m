//
//  TBAudioPlayer.m
//  PlayAudio
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import "PlayLocal.h"
#import "PlayAudio.h"
#import "AudioPlayer.h"
#import "AudioStreamer.h"

#define IS_LOCAL TRUE //定义默认本地播放

@interface AudioPlayer()

@property (readwrite) State state;
@end
@implementation AudioPlayer

@synthesize duration;
@synthesize seekTime;
@synthesize progress;
@synthesize state;

- (id)initwithcontentsOFURL:(NSURL *)url error:(NSError **)outError
{
    if (self == [super init])
    {
        if ([url isFileURL])// url为本地资源
        {
            playAudio = [[PlayLocal alloc] initWithURL:url error:nil];
        }
        else
        {
            playAudio = [[AudioStreamer alloc] initWithURL:url];
        }
    }

    return self;
}

//- (void)dealloc
//{
//    [playAudio release];
//    [super dealloc];
//}

- (BOOL)play
{
    if ([playAudio state] == PLAYING)
    {
        [playAudio stop];
    }
    else
    {
        [playAudio start];
    }
    
    return true;
}

- (void)pause
{
    if (nil != playAudio)
    {
        [playAudio pause];
    }
}

- (void)stop
{
    if (nil != playAudio)
    {
        [playAudio stop];
        
    }
}

- (void)seekToTime:(double)newSeekTime
{
    if (nil != playAudio) {
        [self stop];
        [playAudio seekToTime:newSeekTime];
    }
}

- (State)state
{
    if (nil != playAudio)
    {
        return [playAudio state];
    }
    
    return state;
}

- (void)setState:(State)aState
{
    if (nil != playAudio) {
        if (state != aState) {
            [playAudio setState:aState];
        }
    }
}



@end
