//
//  RegionBackend.m
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "RegionBackend.h"

@implementation RegionBackend

-(instancetype)init
{
    self=[super init];
    if (self) {

    }
    return self;
}

- (RACSignal *)requestRegion:(NSString *)Pid
{
    [progressbar show:YES];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"pid\":\"%@\",\"perPage\":\"100\"}",Pid]
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self.manager
         POST:[NSString stringWithFormat:@"%@/city/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
             [progressbar hide:YES];
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
