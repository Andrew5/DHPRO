//
//  Message.m
//  MusicJoy
//
//  Created by MaKai on 12-12-3.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize title = _title;
@synthesize content = _content;
@synthesize createDate = _createDate;
//@synthesize id = _id;
@synthesize backgroundImage = _backgroundImage;



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeObject:self.backgroundImage forKey:@"backgroundImage"];
//    [aCoder encodeObject:self.id forKey:@"id"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
//        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.createDate = [aDecoder decodeObjectForKey:@"createDate"];
        self.backgroundImage = [aDecoder decodeObjectForKey:@"backgroundImage"];
    }
    return self;
}

@end
