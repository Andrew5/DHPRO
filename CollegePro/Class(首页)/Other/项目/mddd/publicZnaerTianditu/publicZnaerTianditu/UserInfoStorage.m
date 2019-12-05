//
//  UserInfoStorage.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/31.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "UserInfoStorage.h"

#define USER_INFO @"user_info"

#define USER_CURRENT_INFO @"user_current_info"

@implementation UserInfoStorage
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

+ (UserInfoStorage *)defaultStorage{
    static UserInfoStorage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)saveUserInfo:(UserEntity *)user;{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [_userDefault setObject:data forKey:USER_INFO];
}

-(UserEntity *)getUserInfo{
    NSData *data = [_userDefault objectForKey:USER_INFO];
    UserEntity *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

-(void)delUserInfo{
    [_userDefault removeObjectForKey:USER_INFO];
}
//保存最近常用的好友信息

-(void)saveCurrentUser:(NSArray *)userInfor{
    
    [_userDefault setObject:userInfor forKey:USER_CURRENT_INFO];
}

//获取最近访问的好友位置信息
-(NSArray *)getCurrentUser{
    NSArray *userInfor=[_userDefault objectForKey:USER_CURRENT_INFO];
    return userInfor;
    
}

@end
