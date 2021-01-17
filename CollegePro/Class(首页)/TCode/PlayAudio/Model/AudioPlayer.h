//
//  TBAudioPlayer.h
//  PlayAudio
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolBox/AudioToolBox.h"
#import "PlayAudio.h"

@class PlayLocal;
@class AudioStreamer;

@interface AudioPlayer : NSObject
{    
    double seekTime;//跳转时间
    double lastProgress;//进度
    
    id<PlayAudio> playAudio;
    State state;
}

@property (readonly) State state;
@property (nonatomic,assign) double seekTime;
@property (readonly) double progress;
@property (readonly) double duration;


- (id)initwithcontentsOFURL:(NSURL *)url error:(NSError **)outError;
- (BOOL)play;
- (void)seekToTime:(double)newSeekTime;
- (void)pause;
- (void)stop;			

@end
