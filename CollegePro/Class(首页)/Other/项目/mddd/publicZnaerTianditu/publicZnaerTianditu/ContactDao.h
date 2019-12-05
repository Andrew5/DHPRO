//
//  ContactDao.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/24.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseDao.h"
#import "RTDatabaseHelper.h"

@interface ContactDao : BaseDao

//管理类单例
+ (ContactDao *)sharedInstance;

@property(nonatomic,retain)RTDatabaseHelper *dbHelper;

@property(nonatomic,retain)NSString *tableName;



@end
