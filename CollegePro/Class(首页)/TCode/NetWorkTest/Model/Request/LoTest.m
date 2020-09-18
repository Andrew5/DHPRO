//
//  LoTest.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/16.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "LoTest.h"

@implementation LoTest
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
    return @"http://192.168.101.62:8080/api/account/demo";
}
- (instancetype)initWithToken:(NSString *)token
                        accessToken:(NSString *)accessToken{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
        _token = token;
    }
    return self;
}
- (id)requestArgument {

    return @{
            @"accessToken":_accessToken,
            @"token":_token
            };
}
- (NSTimeInterval)requestTimeoutInterval {
    return 2*60;
}
-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
@end
