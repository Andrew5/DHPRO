//
//  BLYHTTPRequest.h
//  NetworkRequestDemo
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLYNetworkDef.h"

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;
@interface BLYHTTPRequest : NSObject
/// 有网YES, 无网:NO
+ (BOOL)isNetwork;

/// 手机网络:YES, 反之:NO
+ (BOOL)isWWANNetwork;

/// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;

/// 取消所有HTTP请求
+ (void)cancelAllRequest;

/// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)reachabilityStatusWithBlock:(BLYReachabilityStatus)reachabilityStatus;

/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

/// 统一设置请求头
+ (NSMutableDictionary *)httpHeaders;

#pragma mark - 网络请求方法
/**
 *  网络请求,无缓存
 *
 *  @param requestMetnod        请求方法
 *  @param URLString            请求地址
 *  @param parameters           请求参数
 *  @param success              请求成功的回调
 *  @param failure              请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (NSURLSessionDataTask *)requestWithMetnod:(BLYHttpRequestMethod)requestMetnod
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(BLYHttpRequestSuccess)success
                                    failure:(BLYHttpRequestFailure)failure;

#pragma mark - 设置AFHTTPSessionManager相关属性
#pragma mark 注意: 因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效
/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置
 (注意: 调用此方法时在要导入AFNetworking.h头文件,否则可能会报找不到AFHTTPSessionManager的❌)
 @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

/**
 *  设置网络请求参数的格式:默认为二进制格式
 *
 *  @param requestSerializer PPRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(BLYRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer PPResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(BLYResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为45S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/// 批量设置请求头
+ (void)setHTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;
@end

NS_ASSUME_NONNULL_END
