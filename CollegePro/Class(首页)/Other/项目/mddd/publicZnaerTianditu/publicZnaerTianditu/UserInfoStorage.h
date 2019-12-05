//
//  UserInfoStorage.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/31.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
@interface UserInfoStorage : NSObject

+ (UserInfoStorage *)defaultStorage;

//保存信息
-(void)saveUserInfo:(UserEntity *)user;
//获取信息
-(UserEntity *)getUserInfo;
//删除信息
-(void)delUserInfo;

//保存最近查找的好友信息
-(void)saveCurrentUser:(NSArray *)userInfor;
//获取最近联系的好友位置信息
-(NSArray *)getCurrentUser;
@end
