//
//  Message.h
//  MusicJoy
//
//  Created by MaKai on 12-12-3.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject<NSCoding>
@property (retain, nonatomic)NSString *title;
@property (retain, nonatomic)NSString *content;
@property (retain, nonatomic)NSString *createDate;
@property (retain, nonatomic)NSString *backgroundImage;
@end
