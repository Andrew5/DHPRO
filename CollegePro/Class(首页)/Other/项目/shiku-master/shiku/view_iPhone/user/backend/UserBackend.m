//
//  UserBackend.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserBackend.h"
#import "App.h"
#import "Cart.h"
#import <XZFramework/MBProgressHUD.h>
@implementation UserBackend
- (id)init
{
    self = [super init];
    if (self) {
        self.repository = [UserRepository shared];
        self.assembler=[UserAssembler new];
    }
    return self;
}

+ (instancetype)shared
{
    static UserBackend *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

#pragma UserCoupon
/**
 *  用户优惠券
 *
 *  @param filter 优惠券
 *  @param user   当前用户，预留可以为空
 *
 *  @return RACSignal
 */
- (RACSignal *)requestCouponList:(FILTER *)filter withUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    [data setValue:user.user_id forKey:@"userid"];
    
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
         POST:[NSString stringWithFormat:@"%@/quan/lists",
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
                                                   [self.assembler userCouponList:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler userFavGoodsList:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
- (RACSignal *)requestCheckoutCouponList:(FILTER *)filter withUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
//    [data setValue:user.user_id forKey:@"userid"];
    [data setValue:filter.keywords forKey:@"total"];
    
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
         POST:[NSString stringWithFormat:@"%@/cart/get_quan_list",
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
                                                   [self.assembler userCouponList:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler userFavGoodsList:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}


#pragma UserInfomation
/**
 *  用户消息
 *
 *  @param filter 消息专题
 *  @param user   当前用户，预留可以为空
 *
 *  @return RACSignal
 */
- (RACSignal *)requestInfomationList:(FILTER *)filter withUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    [data setValue:user.user_id forKey:@"userid"];
    
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
         POST:[NSString stringWithFormat:@"%@/message/lists",
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
                                                   [self.assembler userInformationList:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler userFavGoodsList:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

}
- (RACSignal *)requestCouponDetails:(FILTER *)filter withUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
//    if (filter.pagenation.page>0)
//    {
//        data= [self.assembler paginationToJsonObject:filter.pagenation];
//    }
    [data setValue:filter.status forKey:@"quan_id"];
    
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
         POST:[NSString stringWithFormat:@"%@/cart/get_quan",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 NSMutableDictionary *data=[responseObject objectForKey:@"data"];
                 [subscriber sendNext:[self.assembler coupon:data]];
             }
             else{
                 
                 [subscriber sendNext:[self.assembler userFavGoodsList:nil]];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}

- (RACSignal *)requestRemoveInfomationItems:(NSMutableArray *)items
{
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
    for (COLLECT_GOODS *item in items)
    {
        [itemids appendFormat:@"%d,",[item.rec_id intValue]];
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
         POST:[NSString stringWithFormat:@"%@/message/delete",
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

#pragma userSetting 其他设置

-(RACSignal *)requestUpdateUserSetting:(NSInteger)type withValue:(NSString *)value
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"type\":\"%ld\",\"info\":\"%@\"}",type,value]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user/other_set",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                     [subscriber sendNext:[self.assembler user:[responseObject objectForKey:@"data"]]];
                 }
                 else{
                     [subscriber sendNext:[self.assembler responseResult:responseObject]];
                 }
                 
                 
             }
             else{
                 [subscriber sendNext:[self.assembler user:nil]];
             }

         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


#pragma UserFav //品位
-(RACSignal *)requestAddOrRemoveGrade:(NSInteger)anGradeId isDelete:(BOOL)isDel
{
    NSString *url;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (isDel) {
        url=@"/user_taste/delete";
        [parameters setObject:[NSString stringWithFormat:@"{\"taste_id\":%ld}", anGradeId]
                       forKey:@"data"];
    }
    else
    {
        url=@"/user_taste/add";
        [parameters setObject:[NSString stringWithFormat:@"{\"taste_id\":%ld}", anGradeId]
                       forKey:@"data"];
    }
    
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@%@",
               self.config.backendURL,url]
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

-(RACSignal *)requestGradeList
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
         POST:[NSString stringWithFormat:@"%@/user_taste/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler gradeListWithJSON:[[responseObject objectForKey:@"data"] objectForKey:@"list"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}
-(RACSignal *)requestGradeAddList
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
         POST:[NSString stringWithFormat:@"%@/user_taste/add_lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             [subscriber sendNext:
              [self.assembler gradeListWithJSON:[responseObject objectForKey:@"data"]]];
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


#pragma UserFav //农户

- (RACSignal *)requestUserFavList:(FILTER *)filter withUser:(USER *)user;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    [data setValue:user.user_id forKey:@"userid"];
    
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
         POST:[NSString stringWithFormat:@"%@/user_follow/lists",
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
                                                   [self.assembler userFavGoodsList:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler userFavGoodsList:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
-(RACSignal *)requestAddUserFavItems:(GOODS *)item
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":%d}", [item.shop_id intValue]]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_follow/add",
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

-(RACSignal *)requestRemoveUserFavItems:(NSMutableArray *)items
{
    
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
    for (GOODS *item in items)
    {
        [itemids appendFormat:@"%d,",[item.shop_id intValue]];
    }
    itemids= [itemids substringToIndex:([itemids length]-1)];
    //NSLog(itemids);
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":\"%@\"}",itemids]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_follow/delete",
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

-(RACSignal *)requestRemoveUserFavItems2:(NSMutableArray *)items
{
    
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
    for (COLLECT_GOODS *item in items)
    {
        [itemids appendFormat:@"%d,",[item.shop_id intValue]];
    }
    itemids= [itemids substringToIndex:([itemids length]-1)];
    //NSLog(itemids);
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"follow_uid\":\"%@\"}",itemids]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_follow/delete",
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



#pragma UserAddress
- (RACSignal *)requestDelAddressWithID:(NSInteger)addressID user:(USER *)anUser
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"id\":%d}", (int)addressID]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self POST:[NSString stringWithFormat:@"%@/user_address/delete",
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
- (RACSignal *)requestUpdateAddress:(ADDRESS *)address;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    if (address.rec_id>0) {
        [filter setValue:address.rec_id forKey:@"id"];
    }
    [filter setValue:address.default_address forKey:@"is_default"];
    [filter setValue:address.address forKey:@"address"];
    [filter setValue:address.province_name forKey:@"province"];
    [filter setValue:address.city_name forKey:@"city"];
    [filter setValue:address.district_name forKey:@"area"];
    [filter setValue:address.province forKey:@"province_id"];
    [filter setValue:address.city forKey:@"city_id"];
    [filter setValue:address.district forKey:@"area_id"];
    [filter setValue:address.tel forKey:@"tele"];
    [filter setValue:address.name forKey:@"name"];
    [filter setValue:address.zipcode forKey:@"zipcode"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user_address/update",
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

- (RACSignal *)requestAddressList:(FILTER *)filter withUser:(USER *)anUser;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    [data setValue:anUser.user_id forKey:@"userid"];
    
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
         POST:[NSString stringWithFormat:@"%@/user_address/lists",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 NSMutableDictionary *data=[responseObject objectForKey:@"data"];
                 NSLog(@"%@",data);
                 filter.pagenation=[self.assembler pagination:[data objectForKey:@"pageInfo"]];
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler listAddresses:[data objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler listAddresses:nil])];
             }

         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}


#pragma UserLike
- (RACSignal *)requestUserLikeList:(FILTER *)filter withUser:(USER *)user;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
  
    if (filter.pagenation.page>0)
    {
        data= [self.assembler paginationToJsonObject:filter.pagenation];
    }
    [data setValue:user.user_id forKey:@"userid"];
    
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
         POST:[NSString stringWithFormat:@"%@/user_like/lists",
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
                                                   [self.assembler userLikeGoodsList:[[responseObject objectForKey:@"data"] objectForKey:@"list"]])];
             }
             else{
                 
                 [subscriber sendNext:RACTuplePack(filter,
                                                   [self.assembler userLikeGoodsList:nil])];
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
-(RACSignal *)requestAddUserLikeItems:(GOODS *)item
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"item_id\":%ld}", [item.goods_id integerValue]]
                   forKey:@"data"];
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

-(RACSignal *)requestRemoveUserLikeItems:(NSMutableArray *)items
{
    
    NSMutableString *itemids=[[NSMutableString alloc] initWithCapacity:0];
    for (COLLECT_GOODS *item in items)
    {
        [itemids appendFormat:@"%d,",[item.goods_id intValue]];
    }

    itemids= [itemids substringToIndex:([itemids length]-1)];
    //NSLog(itemids);
    
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"{\"item_id\":\"%@\"}",itemids]
                   forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_like/delete",
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

#pragma UserLogin
-(RACSignal *)requestAuthenticate:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    
    [filter setValue:[NSNumber numberWithInteger:user.user_id] forKey:@"id"];
    [filter setValue:user.name forKey:@"tele"];
    [filter setValue:user.password forKey:@"password"];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/login",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 [subscriber sendNext:[self.assembler user:[responseObject objectForKey:@"data"]]];
             }
             else{
                 [subscriber sendNext:[self.assembler user:nil]];
             }
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];

}
-(RACSignal *)requestAuthenticateUserBind:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"data"] = [NSString stringWithFormat:@"{\"type\":\"%@\",\"keyid\":\"%@\"}", user.usertype,user.keyid];
    // TODO: 格式化
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_bind/callback",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             //[subscriber sendNext:[self.assembler responseResult:responseObject]];
             
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 //DDLogVerbose(@"authenticate success.%@",responseObject);
                 [subscriber sendNext:[self.assembler user:[responseObject objectForKey:@"data"]]];
             }
             else{
                 [subscriber sendNext:[self.assembler user:nil]];
                 //                 DDLogVerbose(@"authenticate failer.%@",responseObject);
                 //                 NSError *error;
                 //                 NSDictionary *errorDescription;
                 //                 errorDescription = @{ NSLocalizedDescriptionKey: [responseObject objectForKey:@"result"] };
                 //                 error = [NSError errorWithDomain:@"UserAuthentication"
                 //                                             code:0
                 //                                         userInfo:errorDescription];
                 //                 [subscriber sendError:error];
             }
             
             //[responseObject objectForKey:@"status"]
             
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
- (RACSignal *)requestAuthenticateUserBindAdd:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"data"] = [NSString stringWithFormat:@"{\"type\":\"%@\",\"keyid\":\"%@\"}", user.usertype,user.keyid];
    // TODO: 格式化
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self
         POST:[NSString stringWithFormat:@"%@/user_bind/add",
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

-(RACSignal *)requestRegister:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    
    [filter setValue:user.user_id forKey:@"id"];
    [filter setValue:user.tele forKey:@"tele"];
    [filter setValue:user.password forKey:@"password"];
    [filter setValue:user.name forKey:@"username"];
    NSLog(@"filter's value is %@",filter);
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/register",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {
             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 [subscriber sendNext:[self.assembler user:[responseObject objectForKey:@"data"]]];
             }
             else{
                 [subscriber sendNext:[self.assembler user:nil]];
             }
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}
-(RACSignal *)requestResetPsw:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    [filter setValue:user.password forKey:@"newpassword"];
    [filter setValue:user.tele forKey:@"tele"];
    //    [filter setValue:address.city forKey:@"city"];
    //    [filter setValue:address.district forKey:@"area"];
    //    [filter setValue:address.cellPhone forKey:@"tele"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/resetPassword",
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
/**
 *  修改密码
 *
 */
-(RACSignal *)requestChangePsw:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    [filter setValue:user.tele forKey:@"tele"];
    [filter setValue:user.newpassword forKey:@"oldpassword"];
    [filter setValue:user.password forKey:@"newpassword"];
    [filter setValue:[NSString stringWithFormat:@"%d",2] forKey:@"type"];
    //    [filter setValue:address.city forKey:@"city"];
    //    [filter setValue:address.district forKey:@"area"];
    //    [filter setValue:address.cellPhone forKey:@"tele"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/resetPassword",
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

- (RACSignal *)requestUser:(AccessToken *)accessToken
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/get",
               self.config.backendURL]
         parameters:parameters
         success:^(AFHTTPRequestOperation *operation,
                   id responseObject) {

             NSInteger status=[[responseObject objectForKey:@"status"] integerValue];
             if(status)
             {
                 [subscriber sendNext:[self.assembler user:[responseObject objectForKey:@"data"]]];
             }
             else{
                 [subscriber sendNext:[self.assembler user:nil]];
             }
         } failure:^(AFHTTPRequestOperation *operation,
                     NSError *error) {
             [subscriber sendError:error];
         }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
}

- (RACSignal *)requestUpdateUserAvatar:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    
    [filter setValue:[NSNumber numberWithInteger:user.user_id] forKey:@"id"];
    [filter setValue:user.avatarimg forKey:@"file"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/avatar",
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


-(RACSignal *)requestSaveUser:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    
    [filter setValue:user.user_id forKey:@"id"];
    [filter setValue:user.name forKey:@"username"];
    [filter setValue:user.email forKey:@"email"];
    [filter setValue:user.sex forKey:@"sex"];
    [filter setValue:user.birthday forKey:@"birthday"];
    [filter setValue:user.intro forKey:@"intro"];
    [filter setValue:user.card_id forKey:@"idcard"];
    [filter setValue:user.provence forKey:@"province"];
    [filter setValue:user.city forKey:@"city"];
    [filter setValue:user.area forKey:@"area"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/user/update",
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
-(RACSignal *)requestPhoneCode:(USER *)user
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *filter = [[NSMutableDictionary alloc] init];
    [filter setValue:user.tele forKey:@"tele"];
    
    NSError *error;
    NSData *dumps = [NSJSONSerialization dataWithJSONObject:filter options:0
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
         POST:[NSString stringWithFormat:@"%@/sms/send_verify_code",
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


-(void)clearStore
{
    [self.repository clearUserStore];
    [Cart clearCart];
}
- (USER *)restore
{
    USER *user = [self.repository restore];
    if (user) {
        [[App shared] setCurrentUser:user];
        NSLog(@"%@",[App shared].currentUser.token);
    }
    
    return user;
}
- (RACSignal*)requestPresident:(USER *)user autherCode:(NSString *)code
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:user.token forKey:@"token"];
    
    NSDictionary *dic = @{@"push_code":code};
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    [parameters setObject:tempData forKey:@"data"];
    @weakify(self)
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        [self POST:[NSString stringWithFormat:@"%@/cooperation/bindProprieter",
                    self.config.backendURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:[self.assembler responseResult:responseObject]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [subscriber sendNext:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

@end
