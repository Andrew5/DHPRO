//
//  Backend.m
//  btc
//
//  Created by txj on 15/1/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Backend.h"
#import "App.h"
@implementation Backend
- (id)init {
    self = [super init];
    if (self) {
        self.config = [TConfig shared];
        //self.manager = [AFHTTPRequestOperationManager manager];
        App *app = [App shared];
        self.manager = app.manager;
        self.currUser = app.currentUser;
    }
    return self;
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    App *app = [App shared];
    [parameters setObject:[NSString stringWithFormat:@"%@", app.currentUser.token]
                   forKey:@"token"];

    NSDictionary *params = (NSDictionary *) parameters;
    id token = params[@"token"];
    if ([params[@"token"] isEqual:@"(null)"]) {
        token = @"";

    }
    else{
        
    }
    NSLog(@"curl %@ -d 'token=%@&data=%@'", URLString, token, params[@"data"]);
//    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self.manager
            POST:URLString
      parameters:parameters
         success:success failure:failure];
}

@end
