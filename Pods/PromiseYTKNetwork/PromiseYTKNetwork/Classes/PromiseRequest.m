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


- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
