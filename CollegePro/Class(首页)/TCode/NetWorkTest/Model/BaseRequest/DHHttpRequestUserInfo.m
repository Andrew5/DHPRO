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
    return @"https://sitservice.lilyclass.com/api/user";
}

-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}


//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    if (self.needToken) {
        return @{
            @"did":@"CB55E0B1-AD0A-46E9-B566-F732BB478C04",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1599217293",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.3.0",
            @"Authorization":[NSString stringWithFormat:@"Bearer %@",[[DHTool userTokenObj] objectForKey:@"access_token"]]
        };
    }else{
        return @{
            @"did":@"CB55E0B1-AD0A-46E9-B566-F732BB478C04",
            @"os":@"1",
            @"channel":@"001",
            @"reqTime":@"1599217293",
            @"osVer":@"iPhone-13.5.1",
            @"ver":@"2.3.0"
            
        };
    }
    
}
@end
