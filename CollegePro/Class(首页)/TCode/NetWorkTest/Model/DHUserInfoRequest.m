//
//  DHUserInfoRequest.m
//  CollegePro
//
//  Created by admin on 2020/8/30.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHUserInfoRequest.h"

@implementation DHUserInfoRequest
//初始化的时候将两个参数值传入
- (id)init{
    self = [super init];
    if (self) {

    }
    return self;
}
//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
   //设置通用header 签名
   return @{
       @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
       @"os":@"1",
       @"channel":@"001",
       @"reqTime":@"1598694276",
       @"osVer":@"iPhone-13.5.1",
       @"ver":@"2.2.0",
       @"access_token":@"eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJsaWx5Q2xhc3NPbmxpbmUiLCJzdWIiOiJ7XCJsYXN0TG9naW5EYXRlXCI6XCIyMDIwLTA4LTI5IDE1OjQxOjEyLjg5N1wiLFwidXNlcklkXCI6MjM1MjYsXCJ1c2VybmFtZVwiOlwiMTMxMDk5MzU1MTFcIn0iLCJhdWQiOiJtb2JpbGUiLCJpYXQiOjE1OTg2ODY4NzIsImV4cCI6MTU5ODc3MzI3Mn0.HcGyjq2GpEUpOJvAzropsBwPb9Mo_tcG_J2OzMJyClYnv4uNKlXFrRK8g0q5agNDjwZSIrwfyMM6ks9cnTzLtQ"
   };
}
//需要和baseUrl拼接的地址
- (NSString *)requestUrl {
    return @"/api/user";
}

//请求方法，某人是GET
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}
@end
