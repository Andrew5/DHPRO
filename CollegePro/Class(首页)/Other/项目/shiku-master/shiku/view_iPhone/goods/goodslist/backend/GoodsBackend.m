//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsBackend.h"

@implementation GoodsBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[GoodsAssembler new];
    }
    return self;
}
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

-(RACSignal *)requestGoodsWithId:(NSNumber *)goods_id
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
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
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/item/get",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler goodsWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
- (RACSignal *)requestGoodsListWithFilter:(FILTER *)filter
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    if (filter.category_id)
        [data setValue:filter.category_id
                  forKey:@"cate_id"];
    if (filter.keywords)
        [data setValue:filter.keywords
                  forKey:@"keyword"];
    
    if (filter.sort_field)
        [data setValue:filter.sort_field forKey:@"order"];
    
    if (filter.sort_by)
        [data setValue:filter.sort_by forKey:@"order_by"];
//    [data setValue:user.user_id forKey:@"id"];
    
    if (filter.status) {
        [data setValue:filter.status forKey:@"status"];
    }
    
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
         POST:[NSString stringWithFormat:@"%@/item/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 NSMutableDictionary *data=[responseObject objectForKey:@"data"];
                 filter.pagenation=[self.assembler pagination:[data objectForKey:@"pageInfo"]];
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler goodsListWithJSON:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler goodsListWithJSON:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
//-(RACSignal *)requestAddFavItem:(GOODS *)goods
//{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":%ld}", [goods.goods_id integerValue]]
//                   forKey:@"data"];
//    @weakify(self)
//    return
//    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        [self
//         POST:[NSString stringWithFormat:@"%@/user_follow/add",
//               self.config.backendURL]
//         parameters:parameters
//         success:^(AFHTTPRequestOperation *operation,
//                   id responseObject) {
//             [subscriber sendNext:
//              [self.assembler responseResult:responseObject]];
//         } failure:^(AFHTTPRequestOperation *operation,
//                     NSError *error) {
//             [subscriber sendError:error];
//         }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//    }];
//    
//}
//-(RACSignal *)requestRemoveFavItems:(NSMutableArray *)items
//{
//    
//    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
//    for (GOODS *item in items)
//    {
//        [itemids appendFormat:@"%d,",[item.rec_id intValue]];
//    }
//    itemids= [itemids substringToIndex:([itemids length]-1)];
//    //NSLog(itemids);
//    
//    
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":\"%@\"}",itemids]
//                   forKey:@"data"];
//    @weakify(self)
//    return
//    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        [self
//         POST:[NSString stringWithFormat:@"%@/user_follow/delete",
//               self.config.backendURL]
//         parameters:parameters
//         success:^(AFHTTPRequestOperation *operation,
//                   id responseObject) {
//             [subscriber sendNext:[self.assembler responseResult:responseObject]];
//         } failure:^(AFHTTPRequestOperation *operation,
//                     NSError *error) {
//             [subscriber sendError:error];
//         }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//    }];
//}

//-(RACSignal *)requestAddShopFavItem:(GOODS *)goods
//{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":%ld}", [goods.goods_id integerValue]]
//                   forKey:@"data"];
//    @weakify(self)
//    return
//    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        [self
//         POST:[NSString stringWithFormat:@"%@/user_follow/add",
//               self.config.backendURL]
//         parameters:parameters
//         success:^(AFHTTPRequestOperation *operation,
//                   id responseObject) {
//             [subscriber sendNext:
//              [self.assembler responseResult:responseObject]];
//         } failure:^(AFHTTPRequestOperation *operation,
//                     NSError *error) {
//             [subscriber sendError:error];
//         }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//    }];
//    
//}
//-(RACSignal *)requestRemoveShopFavItems:(NSMutableArray *)items
//{
//    
//    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
//    for (GOODS *item in items)
//    {
//        [itemids appendFormat:@"%ld,",[item.goods_id integerValue]];
//    }
//    itemids= [itemids substringToIndex:([itemids length]-1)];
//    //NSLog(itemids);
//    
//    
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":\"%@\"}",itemids]
//                   forKey:@"data"];
//    @weakify(self)
//    return
//    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        [self
//         POST:[NSString stringWithFormat:@"%@/user_follow/delete",
//               self.config.backendURL]
//         parameters:parameters
//         success:^(AFHTTPRequestOperation *operation,
//                   id responseObject) {
//             [subscriber sendNext:[self.assembler responseResult:responseObject]];
//         } failure:^(AFHTTPRequestOperation *operation,
//                     NSError *error) {
//             [subscriber sendError:error];
//         }];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//    }];
//}
//

@end
