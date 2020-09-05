//
//  DHHttpRequestLoginLogin.m
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestLoginLogin.h"

@implementation DHHttpRequestLoginLogin

//    NSString *secretKey = [NSString stringWithFormat:@"%@%@%@",[LilyTools userDefaultObjectForKey:AppSecSretkey],parameters[@"username"],parameters[@"password"]];
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    return @"https://sitservice.lilyclass.com/api/auth/login";
}
- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}
- (id)requestArgument {
    return @{
            @"username":_username,
            @"password":_password,
            @"secretKey":@"81df9161be6115e1a0cb335c74b2a2f9"
            };
}
- (NSTimeInterval)requestTimeoutInterval {
    return 10;
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
-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}


@end
