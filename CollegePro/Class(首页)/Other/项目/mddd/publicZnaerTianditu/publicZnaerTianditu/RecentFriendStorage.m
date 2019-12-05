//
//  RecentFriendStorage.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/30.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "RecentFriendStorage.h"

#define RECENT_FRIEND @"recent_friend"

@implementation RecentFriendStorage
{
    NSUserDefaults *_userDefault;
}


-(id)init{
    
    self = [super init];
    
    if (self) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
    
}

+(RecentFriendStorage *)defaultStorage{
    static RecentFriendStorage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)saveFriend:(NSArray *)arrayEntity;{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrayEntity];
    [_userDefault setObject:data forKey:RECENT_FRIEND];
}

-(NSArray *)getAllFriend{
    NSData *data = [_userDefault objectForKey:RECENT_FRIEND];
    NSArray *arrayEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arrayEntity;
}

@end
