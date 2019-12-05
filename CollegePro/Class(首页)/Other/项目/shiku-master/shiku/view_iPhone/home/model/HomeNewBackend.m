//
//  HomeNewBackend.m
//  shiku
//
//  Created by  on 15/9/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeNewBackend.h"

@implementation HomeNewBackend


-(RACSignal *)requestGoodsDetailsWithId:(NSNumber *)goods_id
{
    //测试
    //
    //        goods_id = [NSNumber numberWithInt:10];
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:goods_id forKey:@"id"];
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
         POST:[NSString stringWithFormat:@"%@/item/detail",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler goodsDetailsWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(void)requestGoodsWithId:(NSNumber *)goods_id
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    self.assembler = [[HomeNewAssembler alloc]init];
    if (!goods_id) {
        [data setObject:@"0" forKey:@"id"];
    }
    else{
        [data setObject:goods_id forKey:@"id"];
    }
    //    [data setObject:@"470" forKey:@"id"];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:data options:0
                                                      error:&error];
    NSString *requestJSON;
    requestJSON = [[NSString alloc] initWithData:dumps
                                        encoding:NSUTF8StringEncoding];
    [parameters setObject:requestJSON forKey:@"data"];
    
   
        [self
         POST:[NSString stringWithFormat:@"%@/item/get",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
            
             [self.delegate sendDataBack:[self.assembler goodsWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             
             
         }];
        
}



@end
