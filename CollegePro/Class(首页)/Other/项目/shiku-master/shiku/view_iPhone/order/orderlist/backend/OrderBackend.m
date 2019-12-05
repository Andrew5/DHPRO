//
//  OrderBackend.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderBackend.h"

@implementation OrderBackend
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.assembler=[OrderAssembler new];
    }
    return self;
}
- (RACSignal *)requestOrderListWithUser:(FILTER *)filter withUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
//    [data setValue:user.user_id forKey:@"id"];
    
    if (filter.status) {
        [data setValue:filter.status forKey:@"status"];
    }
    NSLog(@"%@",filter.status);
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
         POST:[NSString stringWithFormat:@"%@/order/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 NSLog(@"%@",responseObject);
                 NSMutableDictionary *data=[responseObject objectForKey:@"data"];
                 filter.pagenation=[self.assembler pagination:[data objectForKey:@"pageInfo"]];
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler ordersWithJSON:[[responseObject objectForKey:@"data"] objectForKey:@"list"]index:filter.status])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler ordersWithJSON:nil index:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [self.delegate sendEorrBack];
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
- (RACSignal *)requestAddOrder:(Cart *)cart express_type:(NSString *)express_type quanData:(NSDictionary *)quanData to_area_id:(NSString *)to_area_id
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderinfo=[[NSMutableDictionary alloc] init];
    ADDRESS *addr=cart.address;
    
    
    //    [orderinfo setObject:itemlist.store.pickUptime forKey:@"store_time"];
    //    [orderinfo setObject:itemlist.store.pickUpdate forKey:@"store_date"];
    [orderinfo setObject:@"3" forKey:@"pays"];
    [orderinfo setObject:@"0" forKey:@"score"];
    [orderinfo setObject:express_type forKey:@"express_type"];
    if (quanData&&[quanData count]>0) {
        [orderinfo setObject:[quanData objectForKey:@"proprieter_id"] forKey:@"proprieter_id"];
        [orderinfo setObject:[quanData objectForKey:@"code"] forKey:@"code"];
        [orderinfo setObject:[quanData objectForKey:@"token"] forKey:@"token"];
        [orderinfo setObject:[quanData objectForKey:@"type"] forKey:@"type"];
        [orderinfo setObject:[quanData objectForKey:@"youhui"] forKey:@"youhui"];
    }
    else
    {
        [orderinfo setObject:@"" forKey:@"proprieter_id"];
        [orderinfo setObject:@"" forKey:@"code"];
        [orderinfo setObject:@"" forKey:@"token"];
        [orderinfo setObject:@"" forKey:@"type"];
        [orderinfo setObject:@"" forKey:@"youhui"];

    
    
    }
   
    [orderinfo setObject:addr.tel forKey:@"addr_tele"];
    [orderinfo setObject:to_area_id forKey:@"to_area_id"];
    [orderinfo setObject:addr.consignee forKey:@"addr_name"];
    //省份
    [orderinfo setObject:addr.province_name forKey:@"addr_province"];
    //城市
    [orderinfo setObject:addr.city_name forKey:@"addr_city"];
    //区县
    [orderinfo setObject:addr.district_name forKey:@"addr_area"];
    [orderinfo setObject:addr.address forKey:@"addr_address"];
    [orderinfo setObject:addr.zipcode forKey:@"addr_zipcode"];
    [orderinfo setObject:@"" forKey:@"remark"];
    
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
//    for (SHOP_ITEM *item in cart.checkout_shop_list)
//    {
//    
//        [itemids appendFormat:@"%ld,",(long)[item.rec_id integerValue]];
//    }
    for(SHOP_ITEM *item in cart.checkout_shop_list)
    {
        for (CART_GOODS *gd in item.cart_goods_list) {
    //            NSMutableDictionary *itemobj=[[NSMutableDictionary alloc] initWithCapacity:cart.checkout_shop_list.count];
    //            [itemobj setValue:gd.goods_id forKey:@"item_id"];
    //            [itemobj setValue:gd.goods_strattr forKey:@"attr"];
            [itemids appendFormat:@"%ld,",(long)[gd.rec_id integerValue]];
        }
            
    }

    itemids= [itemids substringToIndex:([itemids length]-1)];
    
//    NSMutableArray *items=[[NSMutableArray alloc] initWithCapacity:cart.checkout_shop_list.count];
//    
//    for(SHOP_ITEM *item in cart.checkout_shop_list)
//    {
//        for (CART_GOODS *gd in item.cart_goods_list) {
////            NSMutableDictionary *itemobj=[[NSMutableDictionary alloc] initWithCapacity:cart.checkout_shop_list.count];
////            [itemobj setValue:gd.goods_id forKey:@"item_id"];
////            [itemobj setValue:gd.goods_strattr forKey:@"attr"];
//            [items addObject:gd.rec_id];
//        }
//        
//    }
    [orderinfo setObject:itemids forKey:@"items"];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:orderinfo options:0
                                                      error:&error];
    NSString *requestJSON;
    requestJSON = [[NSString alloc] initWithData:dumps
                                        encoding:NSUTF8StringEncoding];
    
    [parameters setObject:requestJSON forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        // [subscriber sendNext:[self.assembler responseResult:nil]];
        [self
         POST:[NSString stringWithFormat:@"%@/order/add",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:[self.assembler orderWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

}
- (RACSignal *)requestConfirmOrder:(ORDER *)order 
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"id\":%d}", [order.rec_id intValue]]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/order/orderConfirm",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
-(RACSignal *)requestCloseOrder:(ORDER *)order
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"id\":%d}", [order.rec_id intValue]]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/order/orderClose",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}

- (RACSignal *)requestcouponCode:(NSString *)couponCode totalPrice:(NSString *)totalPrice items:(NSArray *)Goods_id
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
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

    
    [parameters setObject:[NSString stringWithFormat:@"{\"items\":%@,\"code\":\"%@\",\"totalPrice\":\"%@\"}",m_Goods, couponCode,totalPrice]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/quan/get",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler responseResult:responseObject]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
