//
//  TempAuditDao.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/15.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseDao.h"
#import "FriendEntity.h"


@interface TempAuditDao : BaseDao

//管理类单例
+ (TempAuditDao *)sharedInstance;

//保存
-(void)saveTempFriend:(FriendEntity *)entity;

//查询
-(NSArray *)getAllDatas;

//删除
-(void)deleteData:(FriendEntity *)entity;

//修改
-(void)updateFriendAuditState:(FriendEntity *)entity;

@end
