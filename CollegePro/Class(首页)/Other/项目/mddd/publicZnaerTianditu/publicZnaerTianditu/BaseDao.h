//
//  BaseDao.h
//  ZLYDoc
//  https://gist.github.com/lvjian700/6113564
//  Created by Ryan on 14-4-15.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTDatabaseHelper.h"
#import "YTKKeyValueStore.h"
@interface BaseDao:NSObject<DatabaseDelegate>
//获取表名
-(NSDictionary *)getTableNames;

-(id)init;

-(void)clearAllTable;

@property(nonatomic,strong)YTKKeyValueStore *store;

@end
