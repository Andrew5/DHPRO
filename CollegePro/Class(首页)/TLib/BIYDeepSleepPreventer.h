//
//  BIYDeepSleepPreventer.h
//  BIYong
//
//  Created by baige on 2018/4/8.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;


@interface BIYDeepSleepPreventer : NSObject


#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) NSTimer       *preventSleepTimer;

#pragma mark -
#pragma mark Public Methods

+ (BIYDeepSleepPreventer *)shared;

- (void)startPreventSleep;
- (void)stopPreventSleep;

@end
