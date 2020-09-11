//
//  SFHttpSessionReq.h
//  CollegePro
//
//  Created by jabraknight on 2019/6/12.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ResponseHander)(NSDictionary * _Nullable resData);
typedef void(^ResErrHander)(NSString * _Nullable error);

@interface SFHttpSessionReq : NSObject
+ (instancetype) shareInstance;
- (void)POSTRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters resHander:(ResponseHander) hander resError:(ResErrHander) errHander;
@end

NS_ASSUME_NONNULL_END
