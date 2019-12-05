//
//  ZTHttpRequestServer.h
//  ZinTaoSellerAPP
//
//  Created by hupeng on 16/6/14.
//  Copyright © 2016年 cherrySmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN
@class ECHttpRequestServer;
typedef void (^ _Nullable Success)(id responseObject);     // 成功Block
typedef void (^ _Nullable Failure)(NSError *error);        // 失败Blcok
typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress); // 上传或者下载进度Block

@interface ECHttpRequestServer : AFHTTPSessionManager

///**
// *  超时时间(默认20秒)
// */
//@property (nonatomic, assign) NSTimeInterval timeoutInterval;
//


@property(nonatomic,strong)NSURLSessionDataTask *theTask;

/*获取单离*/
+ (instancetype)sharedClient;
/*取消请求*/
- (void) cancelRequest;
/*post 请求*/
- (NSURLSessionDataTask *) PostZT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(_Nullable Success)success failure:(_Nullable Failure)failure;
/*get 请求*/
- (void) GetZT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(_Nullable Success)success failure:(_Nullable Failure)failure;

@end

NS_ASSUME_NONNULL_END
