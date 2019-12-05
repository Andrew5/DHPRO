//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeBackend.h"

@implementation HomeBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[HomeAssembler new];
    }
    return self;
}
- (RACSignal *)requestHomeItems;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//    [data setObject:[[NSNumber alloc] initWithInteger:goods_id] forKey:@"id"];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:data options:0
                                                      error:&error];
    NSString *requestJSON;
    requestJSON = [[NSString alloc] initWithData:dumps
                                        encoding:NSUTF8StringEncoding];
    [parameters setObject:requestJSON forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/index/get",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
#pragma mark -
#pragma mark 网络请求 修改过
             if (responseObject == nil) {
                 return ;
             }
             [subscriber sendNext:
              [self.assembler homeItem:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
@end
