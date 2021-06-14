//
//  D3RecordButton.h
//  D3RecordButtonDemo
//
//  Created by bmind on 15/7/28.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mp3Recorder.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>

@protocol D3RecordDelegate <NSObject>
- (void)endRecord:(NSData *)voiceData;

@optional
- (void)recording:(float) recordTime;
- (void)dragExit;
- (void)dragEnter;
@end

@interface D3RecordButton : UIButton<Mp3RecorderDelegate>{
    int maxTime;
    Mp3Recorder *mp3;
    NSString *title;
}
@property (nonatomic,weak) id<D3RecordDelegate> delegate;

- (void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime title:(NSString*)title;
- (void)initRecord:(id<D3RecordDelegate>)delegate maxtime:(int)_maxTime;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
