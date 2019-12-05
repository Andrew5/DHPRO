//
//  BaseDao.m
//  ZLYDoc
//
//  Created by Ryan on 14-4-15.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "BaseDao.h"
#import "FMDatabase.h"
#import "Constants.h"
@implementation BaseDao

-(id)init{
    self = [super init];
    if (self) {
        self.store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
    }
    
    return self;
}

-(NSDictionary *)getTableNames
{
    NSString *sqlFilePath = [[NSBundle mainBundle] pathForResource:@"sql" ofType:@"plist"];
    NSDictionary *dic_sql = [NSDictionary dictionaryWithContentsOfFile:sqlFilePath];
    return dic_sql;
}

-(void)createTable:(NSString *)sql
{
    FMDatabase *db = [[RTDatabaseHelper sharedInstance] openDatabase];
    if (![db executeUpdate:sql]) {
        NSLog(@"Create table failed");
    }
    [db close];
}

-(void)clearAllTable{
    NSDictionary *tableNames = [self getTableNames];
    NSArray *keys = [tableNames allKeys];
    for (NSString *key in keys) {
        [self.store clearTable:[tableNames objectForKey:key]];
    }
}


@end
