//
//  BLYNetworkDef.h
//  NetworkRequestDemo
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 admin. All rights reserved.
//

#ifndef BLYNetworkDef_h
#define BLYNetworkDef_h

typedef NS_ENUM(NSInteger, BLYNweworkReachabilityStatus) {
    /// 未知网络
    BLYNetworkReachabilityStatusUnknown          = -1,
    /// 无网络
    BLYNetworkReachabilityStatusNotReachable     = 0,
    /// 手机网络
    BLYNetworkReachabilityStatusReachableViaWWAN = 1,
    /// WIFI网络
    BLYNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, BLYRequestSerializer) {
    /// 设置请求数据为二进制格式
    BLYRequestSerializerHTTP,
    /// 设置请求数据为JSON格式
    BLYRequestSerializerJSON
};

typedef NS_ENUM(NSUInteger, BLYResponseSerializer) {
    /// 设置响应数据为二进制格式
    BLYResponseSerializerHTTP,
    /// 设置响应数据为JSON格式
    BLYResponseSerializerJSON
};

typedef NS_ENUM(NSUInteger, BLYHttpRequestMethod) {
    BLYHttpRequestMethodGET,
    BLYHttpRequestMethodHEAD,
    BLYHttpRequestMethodPOST,
    BLYHttpRequestMethodPUT,
    BLYHttpRequestMethodPATCH,
    BLYHttpRequestMethodDELETE,
};


/// 请求成功的Block
typedef void(^BLYHttpRequestSuccess)(id responseObject);

/// 请求失败的Block
typedef void(^BLYHttpRequestFailure)(NSError *error);

/// 缓存的Block
typedef void(^BLYHttpRequestCache)(id responseCache);

/// 网络状态监听Block
typedef void(^BLYReachabilityStatus)(BLYNweworkReachabilityStatus status);

#define ObjectForKey(key)   [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define ContactStr(firstStr, secondStr) [NSString stringWithFormat:@"%@%@", firstStr, secondStr]

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#endif /* BLYNetworkDef_h */
