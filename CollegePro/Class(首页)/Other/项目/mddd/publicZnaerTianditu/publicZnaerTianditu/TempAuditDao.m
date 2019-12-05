//
//  TempAuditDao.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/15.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "TempAuditDao.h"
#import "Constants.h"
#import "MJExtension.h"
@implementation TempAuditDao
{
    NSString *_tableName;
}
-(id)init{
    self = [super init];
    if (self) {
        //存在忽略，不存在就创建
        NSDictionary *tableNames = [self getTableNames];
        _tableName = [tableNames objectForKey:DB_TABLE_TEMP_AUDIT];
        [self.store createTableWithName:_tableName];
    }
    
    return self;
}

+ (TempAuditDao *)sharedInstance{
    static TempAuditDao *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)saveTempFriend:(FriendEntity *)entity{
    
    //这里用用户ID来作为存储数据库的key
    NSString *key = entity.equipId;
    NSNumber *gender = [[NSNumber alloc]initWithInt:entity.gender];
    NSString *imageUrl = entity.equipIcon == nil ? @"":entity.equipIcon;
    NSString *applyDesc = entity.applyDesc == nil ?@"":entity.applyDesc;
    //将模型转成字典保存数据库
    NSDictionary *data = @{@"equipId":entity.equipId,@"equipName":entity.equipName,@"equipIcon":imageUrl,@"gender":gender,@"auditState":[NSNumber numberWithInt:entity.auditState],@"applyDesc":applyDesc};
    
    [self.store putObject:data withId:key intoTable:_tableName];
}

-(NSArray *)getAllDatas{
    NSArray *datas = [self.store getAllItemsFromTable:_tableName];
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:datas.count];
    //将字典数组转为实体类数组
    for (NSUInteger i = datas.count; i > 0; i --) {
        YTKKeyValueItem *item = datas[i - 1];
        NSDictionary *value = item.itemObject;
        FriendEntity *entity = [FriendEntity objectWithKeyValues:value];
        [retArray addObject:entity];
    }
    
    return retArray;
  
}

-(void)deleteData:(FriendEntity *)entity{
    [self.store deleteObjectById:entity.equipId fromTable:_tableName];
}

-(void)updateFriendAuditState:(FriendEntity *)entity{
    [self saveTempFriend:entity];
}

@end
