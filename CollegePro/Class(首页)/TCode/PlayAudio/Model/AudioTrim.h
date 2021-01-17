//
//  AudioTrim.h
//  PlayAudio
//
//  Created by 杨飞 on 10/31/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVAsset.h"

@interface AudioTrim : NSObject

- (BOOL)trimAudio:(NSString *)audioPath toFilePath:(NSString *)filePath startTime:(CMTime)startTime stopTime:(CMTime)stopTime;

@end
