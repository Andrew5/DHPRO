//
//  DHHttpRequestOrdersOrders.m
//  CollegePro
//
//  Created by admin on 2020/9/5.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestOrdersOrders.h"

@implementation DHHttpRequestOrdersOrders
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodGET;
}
- (NSString *)requestUrl{
    return @"https://sitservice.lilyclass.com/api/user/orders";
}
- (id)requestArgument {
    NSArray *arr = @[@{@"type":@"and",
    @"key":@"status",
    @"operation":@"eq",
                       @"value":@"1"}];
    
        arr = @[@{@"type":@"and",
        @"key":@"status",
        @"operation":@"eq",
                  @"value":@(1).stringValue},
        @{@"type":@"or",
        @"key":@"status",
        @"operation":@"eq",
                  @"value":@(4).stringValue},
        @{@"type":@"or",
        @"key":@"status",
        @"operation":@"eq",
                  @"value":@(5).stringValue}];
    
    NSDictionary *dic = @{@"page":@(0),
                  @"size":@"10",
                          @"search":arr,
                  @"sorts":@[@{@"orderType":@"desc",
                             @"orderField":@"id"}]
    };
    NSData *jsData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsString = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    return @{@"json":jsString,@"os":@"1"};
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}
//-(YTKRequestSerializerType)requestSerializerType{
//    return YTKRequestSerializerTypeJSON;
//}
//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    return @{
        @"did":@"CB55E0B1-AD0A-46E9-B566-F732BB478C04",
        @"os":@"1",
        @"channel":@"001",
        @"reqTime":@"1599217293",
        @"osVer":@"iPhone-13.5.1",
        @"ver":@"2.3.0",
        @"Authorization":[NSString stringWithFormat:@"Bearer %@",[[DHTool userTokenObj] objectForKey:@"access_token"]]
    };
}
@end
