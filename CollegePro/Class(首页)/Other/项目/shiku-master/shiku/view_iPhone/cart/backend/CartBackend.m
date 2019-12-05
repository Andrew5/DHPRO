//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CartBackend.h"
#import "Cart.h"
#import "Models.h"
#import "AppDelegate.h"
@implementation CartBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[CartAssembler new];
    }
    return self;
}
- (RACSignal *)requestCartListWithUser:(USER *)anUser
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (_m_filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:_m_filter.pagenation];
    }
//    [data setValue:anUser.user_id forKey:@"id"];
    
    if (_m_filter.status) {
        [data setValue:_m_filter.status forKey:@"status"];
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
         POST:[NSString stringWithFormat:@"%@/cart/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
//             NSLog(@"%@",responseObject);
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 NSMutableArray *data=[responseObject objectForKey:@"data"];
//                 NSLog(@"%@",data);
//                 _m_filter.pagenation=[self.assembler pagination:[data objectForKey:@"pageInfo"]];
                 [subscriber sendNext:RACTuplePack(nil,
                                                   [self.assembler shopItemsWithJSON:data])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(nil,
                                                   [self.assembler shopItemsWithJSON:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}

-(RACSignal *)requestGetExpressPrice:(TOTAL *)total
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    //    if (filter.pagenation.page>0)
    //    {
    //        data= [self.assembler paginationToJsonObject:filter.pagenation];
    //    }
    ////    [data setValue:user.user_id forKey:@"id"];
    //
    //    if (filter.status) {
    [data setValue:total.goods_price forKey:@"total"];
    [data setValue:total.goods_weight forKey:@"weight"];
    //    }
    
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
         POST:[NSString stringWithFormat:@"%@/cart/get_express",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
//                 NSMutableArray *data=[responseObject objectForKey:@"data"];
                 //                 filter.pagenation=[self.assembler pagination:[data objectForKey:@"pageInfo"]];
                 [subscriber sendNext:
                  [responseObject objectForKey:@"express"]];
             }
             else{
                 
                 [subscriber sendNext:nil];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}


-(RACSignal *)requestCartGoodsNum:(CART_GOODS *)anGoods
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"[{\"item_id\":%ld,\"num\":%ld}]", (long)[anGoods.goods_id integerValue],(long)anGoods.goods_number]
                   forKey:@"data"];
//    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
//    if (address.rec_id>0) {
//        [filter setValue:address.rec_id forKey:@"id"];
//    }
    
//    [filter setValue:address.address forKey:@"address"];
//    [filter setValue:address.province forKey:@"province"];
//    [filter setValue:address.city forKey:@"city"];
//    [filter setValue:address.district forKey:@"area"];
//    [filter setValue:address.tel forKey:@"tele"];
//    [filter setValue:address.name forKey:@"name"];
    
//    NSError *error;
//    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
//                                                      error:&error];
//    NSString *requestJSON;
//    requestJSON = [[NSString alloc] initWithData:dumps
//                                        encoding:NSUTF8StringEncoding];
//    [parameters setObject:requestJSON forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cart/update",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
- (RACSignal *)requestAddItemToCart:(CATEGORY *)item andGoodsId:(NSNumber *)goodsId andGoodsNum:(NSInteger)goods_num WithUser:(USER *)anUser
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"[{\"item_id\":%ld,\"num\":%ld,\"attr\":\"%@\"}]", (long)[goodsId integerValue],(long)goods_num,item.name]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cart/add",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

}

- (RACSignal *)requestAddItemToLikeList:(NSString *)goodName andGoodsId:(NSString *)goodsId andGoodsNum:(NSInteger)goods_num WithUser:(USER *)anUser
{
    NSDictionary *dic = @{@"item_id":goodsId};
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:anUser.token forKey:@"token"];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:dic options:0
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
         POST:[NSString stringWithFormat:@"%@/user_like/add",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
-(RACSignal *)requestRemoveCartItems:(NSMutableArray *)items
{
    
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
    for (CART_GOODS *item in items)
    {
        [itemids appendFormat:@"%ld,",(long)[item.rec_id integerValue]];
    }
    itemids= [itemids substringToIndex:([itemids length]-1)];
    //NSLog(itemids);
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"id\":\"%@\"}",itemids]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/cart/delete",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
        
             [subscriber sendNext:[self.assembler responseResult:responseObject]];
            
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

-(RACSignal *)requestGetLogistics:(NSNumber *)Goods_id
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"items\":\"%@\"}",Goods_id]
                   forKey:@"data"];

    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/order/getExpressList",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
            [subscriber sendNext:[self.assembler responseResult:responseObject]];             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)requestexpress_money:(NSMutableArray *)Goods_id to_area_id:(NSString *)area_id express_type:(NSString *)express_type
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];

    NSString * m_Str;
    NSString * GoodStr = [NSString stringWithFormat:@""];
    for (int i = 0; i<[Goods_id count]; i++) {
        if (i==0) {
          GoodStr= [GoodStr stringByAppendingString:[NSString stringWithFormat:@"%@",[Goods_id objectAtIndex:i]]];
            NSLog(@"%@",GoodStr);
        }
        else
        {
             GoodStr = [GoodStr stringByAppendingString:[NSString stringWithFormat:@",%@",[Goods_id objectAtIndex:i]]];
        }
       
    }
    NSString * m_Goods = [NSString stringWithFormat:@"[%@]",GoodStr];
 
    m_Str = [NSString stringWithFormat:@"{\"items\":%@,\"to_area_id\":\"%@\",\"express_type\":\"%@\"}",m_Goods,area_id,express_type];
    
     [m_Str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    [m_Str stringByReplacingOccurrencesOfString:@")" withString:@""];
    [parameters setObject:m_Str
                   forKey:@"data"];
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/order/express_money",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
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
