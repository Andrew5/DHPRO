//
//  DBHelper.m
//  ZLYDoc
//  
//  Created by Ryan on 14-4-14.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import "RTDatabaseHelper.h"
#import "Constants.h"
@implementation RTDatabaseHelper

- (id)init
{
    if (self = [super init]) {
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
		NSString *dbpath = [docsdir stringByAppendingPathComponent:DB_NAME];
		_database = [FMDatabase databaseWithPath:dbpath];
    }
    return self;
}

+ (RTDatabaseHelper *)sharedInstance
{
    static RTDatabaseHelper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (FMDatabase *)openDatabase
{
    if ([_database open]) {
        return _database;
    }
    return nil;
}

- (void)removeAllData
{
    NSDictionary *dic_sql = [self sqlForCreateTable];
    for (NSString *tableName in [dic_sql allKeys]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where 1 = 1",tableName];
        BOOL is_delete = [[[RTDatabaseHelper sharedInstance] openDatabase] executeUpdate:sql];
        NSLog(@"%@",is_delete ? @"Delete all data success...":@"Delete all data failed...");
    }
}

- (BOOL)isTableExists:(NSString *)tableName
{
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    FMResultSet *rs = [[self openDatabase] executeQuery:existsSql];

	if ([rs next]) {
		NSInteger count = [rs intForColumn:@"countNum"];
		if (count == 1) {
			NSLog(@"%@ is existed.",tableName);
			return YES;
		}
        NSLog(@"%@ is not exist.",tableName);
	}
	[rs close];
    
    return NO;
}

- (void)closeDB
{
    dispatch_async(dispatch_get_main_queue(), ^{
		if([_database close]) {
			_database = nil;
		}
	});
}

- (BOOL)deleteDatabase
{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbpath = [docsdir stringByAppendingPathComponent:DB_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:dbpath error:nil];
}

- (NSDictionary *)sqlForCreateTable
{
    NSString *sqlFilePath = [[NSBundle mainBundle] pathForResource:@"sql" ofType:@"plist"];
    NSDictionary *dic_sql = [NSDictionary dictionaryWithContentsOfFile:sqlFilePath];
    return dic_sql;
}

@end
