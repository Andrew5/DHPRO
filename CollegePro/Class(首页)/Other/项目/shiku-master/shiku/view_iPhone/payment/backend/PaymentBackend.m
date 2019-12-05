//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PaymentBackend.h"

@implementation PaymentBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[PaymentAssembler new];
    }
    return self;
}
- (RACSignal *)requestCheckout:(ORDER *)order payId:(NSInteger)payid
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"id\":%ld,\"pays\":%ld,\"platform\":\"ios\"}", (long)[order.rec_id integerValue],(long)payid]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/order/pay",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler paymentWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    
}

@end
