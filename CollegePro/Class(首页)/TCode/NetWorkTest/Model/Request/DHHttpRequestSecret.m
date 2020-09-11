//
//  DHHttpRequestSecret.m
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestSecret.h"

@implementation DHHttpRequestSecret

- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    return @"https://sitservice.lilyclass.com/api/common/secretkey";
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}
-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    if (self.needToken) {
        return @{
            @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1599103287",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.3.0",
            @"Authorization":[NSString stringWithFormat:@"Bearer %@",[[DHTool userTokenObj] objectForKey:@"access_token"]]
        };
    }else{
        return @{
            @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1599103287",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.3.0"
        };
    }
    
}
@end
