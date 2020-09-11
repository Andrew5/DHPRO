//
//  PromiseRequest.m
//  ichangtou
//
//  Created by ONE on 2020/7/7.
//  Copyright © 2020 ichangtou. All rights reserved.
//

#import "PromiseRequest.h"
//#import "YTKNetworkPrivate.h"

@implementation PromiseRequest


- (AnyPromise *)launch {
    

    AnyPromise *result = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            PMKResolver fulfiller = ^(id responseObject){
//                resolve(responseObject);
//                if (responseObject[@"code"] == 2000) {
//                    <#statements#>
//                } else {
//                    <#statements#>
//                }
                resolve(PMKManifold(responseObject));
            };
            
            fulfiller(request.responseJSONObject);
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//            resolve(request.error);
            PMKResolver rejecter = ^(NSError *error){
                resolve(error);
            };
            
            rejecter(request.error);
        }];
    }];
    return result;
}
- (AnyPromise *)statusLaunch {
    
    AnyPromise *result = [AnyPromise promiseWithResolverBlock:^(PMKResolver _Nonnull resolve) {
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            PMKResolver fulfiller = ^(id responseObject){
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) { // 先判断返回的是否是json
                    if ([[responseObject allKeys] containsObject:@"code"]) { // json是否含有code字段
                        if ([responseObject[@"code"] integerValue]== 2000) {
                            resolve(PMKManifold(responseObject));
                        } else {
                            NSString *message = @"接口返回的message为空";
                            if ([[responseObject allKeys] containsObject:@"message"]) { // code不是2000是否含有message字段
                                message = responseObject[@"message"];
                            }
                            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                            NSError *aError = [NSError errorWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:userInfo];
                            resolve(aError);
                        }
                    } else {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"接口返回的code为空" forKey:NSLocalizedDescriptionKey];
                        NSError *aError = [NSError errorWithDomain:NSCocoaErrorDomain code:1971 userInfo:userInfo];
                        resolve(aError);
                    }
                } else {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"接口返回的信息为空" forKey:NSLocalizedDescriptionKey];
                    NSError *aError = [NSError errorWithDomain:NSCocoaErrorDomain code:1970 userInfo:userInfo];
                    resolve(aError);
                }
            };
            
            fulfiller(request.responseJSONObject);
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            PMKResolver rejecter = ^(NSError *error){
                resolve(error);
            };
            
            rejecter(request.error);
        }];
    }];
    return result;

}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
