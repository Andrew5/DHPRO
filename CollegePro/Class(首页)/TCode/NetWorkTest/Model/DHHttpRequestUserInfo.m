//
//  DHHttpRequestUserInfo.m
//  CollegePro
//
//  Created by admin on 2020/8/30.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestUserInfo.h"

@implementation DHHttpRequestUserInfo
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodGET;
}
- (instancetype)init{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}
- (NSString *)description {
    //打印自己认为重要的信息
    return [NSString stringWithFormat:@"%@ \nstatusCode:%ld\nresponseJSONObject:\n%@",super.description,self.responseStatusCode,self.responseJSONObject];
}
- (NSString *)requestUrl{
    return @"/api/user";
}

-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
- (id)requestArgument{
    return @"";
}
//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    if (self.needToken) {
        return @{
            @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1598694276",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.2.0",
            @"Content-Type":@"application/json; charset=utf-8",
            @"access_token":@"eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJsaWx5Q2xhc3NPbmxpbmUiLCJzdWIiOiJ7XCJsYXN0TG9naW5EYXRlXCI6XCIyMDIwLTA4LTMwIDIyOjI4OjUyLjdcIixcInVzZXJJZFwiOjIzNTMxLFwidXNlcm5hbWVcIjpcIjE1MjA5OTMwNzcyXCJ9IiwiYXVkIjoibW9iaWxlIiwiaWF0IjoxNTk4Nzk3NzMyLCJleHAiOjE1OTg4ODQxMzJ9.Rt2DP_yro9FIhxG663PrSsUnlaCh3cUDbsp_MNc6PsdhkEBIn9v__Pz5dSRUggz895YN6fNkv5OASR2a5cSqJA"
        };
    }else{
        return @{
            @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1598694276",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.2.0",
            @"Content-Type":@"application/json; charset=utf-8"
            
        };
    }
    
}
@end
