//
//  MonerBackend.m
//  shiku
//
//  Created by yanglele on 15/9/9.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "MoneyBackend.h"

@implementation MoneyBackend

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[BackendAssembler new];
    }
    return self;
}

-(RACSignal *)GetTheBalance
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"{}"
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cash/balance",
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

-(RACSignal *)GetWithdrawalUserName:(NSString *)UserName money:(NSString *)money card_no:(NSString *)card_no type:(NSString *)type
{

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSString * m_Str = [NSString stringWithFormat:@"{\"username\":\"%@\",\"money\":\"%@\",\"card_no\":\"%@\",\"type\":\"%@\"}",UserName,money,card_no,type];
    [parameters setObject:m_Str
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cash/withDraw",
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

@end
