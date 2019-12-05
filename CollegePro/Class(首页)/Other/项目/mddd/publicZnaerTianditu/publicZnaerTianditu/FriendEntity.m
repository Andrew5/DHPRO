//
//  FriendEntity.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "FriendEntity.h"

@implementation FriendEntity

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.equipId forKey:@"equipID"];
    [aCoder encodeObject:self.equipName forKey:@"equipName"];
    [aCoder encodeObject:self.equipIcon forKey:@"equipIcon"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
      
        self.equipId = [aDecoder decodeObjectForKey:@"equipID"];
        self.equipName = [aDecoder decodeObjectForKey:@"equipName"];
        self.equipIcon = [aDecoder decodeObjectForKey:@"equipIcon"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"]intValue];
    }
    
    return self;
}

@end
