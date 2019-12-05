//
//  FriendDao.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/12.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseDao.h"
#import "FriendEntity.h"
//通讯录数据库操作类
@interface FriendDao : BaseDao

//管理类单例
+ (FriendDao *)sharedInstance;

//单个保存好友信息
-(void)saveFriend:(FriendEntity *)friendEntity;
//保存多个好友信息
-(void)saveFriendArray:(NSArray *)array;
//获取所有好友
-(NSArray *)getAllFriend;
//删除好友
-(void)deleteFriend:(FriendEntity *)friendEntity;
@end
