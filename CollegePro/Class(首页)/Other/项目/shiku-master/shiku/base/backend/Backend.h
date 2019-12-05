//
//  Backend.h
//  btc
//
//  Created by txj on 15/1/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLConnectionOperation.h"
#import "Models.h"

@interface Backend : NSObject
@property (strong, nonatomic) TConfig *config;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) USER *currUser;
- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
