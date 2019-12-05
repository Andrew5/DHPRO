//
//  ContactDao.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/24.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "ContactDao.h"

//plist里获取表名的key
#define CONTACT_KEY @"contact"

#define CREATE_TABLE_SQL(tablename) [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, phonename text, phone text NOT NULL, headimage text, state integer NOT NULL)",tablename]

@implementation ContactDao

@synthesize dbHelper;
@synthesize tableName;

-(id)init{
    
    self = [super init];
    
    if (self) {
      
        dbHelper = [RTDatabaseHelper sharedInstance];
        
        NSDictionary * tableNames = [self getTableNames];
       
        tableName = [tableNames objectForKey:CONTACT_KEY];
     
        [self createTable:CREATE_TABLE_SQL(tableName)];
        
    }
    
    return self;
}

+ (ContactDao *)sharedInstance
{
    static ContactDao *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
