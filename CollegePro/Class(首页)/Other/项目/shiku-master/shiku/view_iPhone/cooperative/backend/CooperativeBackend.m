//
//  CooperativeBackend.m
//  shiku
//
//  Created by yanglele on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CooperativeBackend.h"

@implementation CooperativeBackend

-(RACSignal *)RequestCooperativeMemberIdentity:(NSString *)UserID
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSString * m_Str = [NSString stringWithFormat:@"{\"id\":\"%@\"}",UserID];
    [parameters setObject:m_Str
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cooperation/manage",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             NSLog(@"%@",responseObject);
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    



}

-(RACSignal *)RequestCooperativegetCouponCode
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:@""
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cooperation/getCouponCode",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             NSLog(@"%@",responseObject);
             [subscriber sendNext:responseObject];
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    
    
    
}

@end
