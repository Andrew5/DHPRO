//
//  FriendDao.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/12.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "FriendDao.h"
#import "Constants.h"
#import "MJExtension.h"
@implementation FriendDao
{
    NSString *_tableName;
}

-(id)init{
    self = [super init];
    if (self) {
        //存在忽略，不存在就创建
        NSDictionary *tableNames = [self getTableNames];
        _tableName = [tableNames objectForKey:DB_TABLE_CONTACT];
        [self.store createTableWithName:_tableName];
    }
    
    return self;
}

+ (FriendDao *)sharedInstance
{
    static FriendDao *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)saveFriend:(FriendEntity *)friendEntity
{
    //这里用用户ID来作为存储数据库的key
    NSString *key = friendEntity.equipId;
    NSNumber *gender = [[NSNumber alloc]initWithInt:friendEntity.gender];
    NSString *imageUrl = friendEntity.equipIcon == nil ? @"":friendEntity.equipIcon;
    //将模型转成字典保存数据库
    NSDictionary *data = @{@"equipId":friendEntity.equipId,@"equipName":friendEntity.equipName,@"equipIcon":imageUrl,@"gender":gender};
    
    [self.store putObject:data withId:key intoTable:_tableName];
}

-(void)saveFriendArray:(NSArray *)array
{
    for (FriendEntity *entity in array) {
        [self saveFriend:entity];
    }
}

-(NSArray *)getAllFriend{
    NSArray *datas = [self.store getAllItemsFromTable:_tableName];
    
    NSMutableArray *retDatas = [NSMutableArray arrayWithCapacity:datas.count];
    for (YTKKeyValueItem *item in datas) {
        [retDatas addObject:item.itemObject];
    }
    
    //将字典数组转为实体类数组
    return [FriendEntity objectArrayWithKeyValuesArray:retDatas];
}

-(void)deleteFriend:(FriendEntity *)friendEntity{
    NSString *key = friendEntity.equipId;
    [self.store deleteObjectById:key fromTable:_tableName];
}

@end
