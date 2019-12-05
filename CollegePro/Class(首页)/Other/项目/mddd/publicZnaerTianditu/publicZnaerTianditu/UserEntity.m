//
//  UserEntity.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/31.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

@synthesize loginName = _loginName;
@synthesize to = _to;
@synthesize token = _token;
@synthesize userID = _userID;
@synthesize nickName = _nickName;
@synthesize equipID = _equipID;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.loginName forKey:@"loginName"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.equipID forKey:@"equipID"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
    [aCoder encodeObject:self.equipIcon forKey:@"equipIcon"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
        self.to = [aDecoder decodeObjectForKey:@"to"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.equipID = [aDecoder decodeObjectForKey:@"equipID"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
        self.equipIcon = [aDecoder decodeObjectForKey:@"equipIcon"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"]intValue];
    }
    
    return self;
}

@end
