//
//  APP.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models.h"
@interface App : NSObject

@property (strong, nonatomic) USER *currentUser;//当前用户信息
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
+ (instancetype)shared;
@end
