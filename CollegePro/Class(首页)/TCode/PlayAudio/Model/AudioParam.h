//
//  AudioParam.h
//  PlayAudio
//
//  Created by 杨飞 on 10/25/12.
//  Copyright (c) 2012 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioParam : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *artist;
@property (nonatomic,copy) NSString *album;
@property (nonatomic,copy) NSString *duration;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,retain) NSArray  *artwork;

//获取音乐名称、艺术家、插图等信息
- (id)initWithAudioPath:(NSString *)path;

@end
