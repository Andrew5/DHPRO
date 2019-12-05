//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CateBackend.h"

@implementation CateBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[CateAssembler new];
    }
    return self;
}
-(RACSignal *)requestCateList
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
         POST:[NSString stringWithFormat:@"%@/item_cate/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler cateListWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
@end
