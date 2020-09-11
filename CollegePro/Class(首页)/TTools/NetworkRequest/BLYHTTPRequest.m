//
//  BLYHTTPRequest.m
//  NetworkRequestDemo
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import "BLYHTTPRequest.h"
#import "BLYGetEquipmentInfo.h"

#define kSecretKeyForCSRF       @"YC2d430Re15LbV7t8pfGhJ6k"


@implementation BLYHTTPRequest
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;
static AFHTTPSessionManager *_downLoadManager;

static NSString *const kBLYLoginStatusKey = @"kBLYLoginStatusKey";
static NSString *const kBLYLoginTokenKey = @"kBLYLoginTokenKey";
static NSString *const kBLYLocationInfoKey = @"kBLYLocationInfoKey";
static NSString *const kBLYDeviceTokenKey = @"kBLYDeviceTokenKey";
static NSString *const kBLYUserAgentKey = @"kBLYUserAgentKey";

#pragma mark - 开始监听网络
+ (void)reachabilityStatusWithBlock:(BLYReachabilityStatus)reachabilityStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                !reachabilityStatus ?: reachabilityStatus(BLYNetworkReachabilityStatusUnknown);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                !reachabilityStatus ?: reachabilityStatus(BLYNetworkReachabilityStatusNotReachable);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                !reachabilityStatus ?: reachabilityStatus(BLYNetworkReachabilityStatusReachableViaWWAN);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                !reachabilityStatus ?: reachabilityStatus(BLYNetworkReachabilityStatusReachableViaWiFi);
                break;
        }
    }];
}

+ (BOOL)isNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)cancelAllRequest
{
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL
{
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 网络请求无缓存
+ (NSURLSessionDataTask *)requestWithMetnod:(BLYHttpRequestMethod)requestMetnod
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(BLYHttpRequestSuccess)success
                                    failure:(BLYHttpRequestFailure)failure{
    NSURLSessionDataTask *sessionTask = nil;
       switch (requestMetnod) {
           case BLYHttpRequestMethodGET:{
               sessionTask = [_sessionManager GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                   
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:responseObject task:task  success:success];
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
                   
               }];
               
               
           }
               break;
           case BLYHttpRequestMethodHEAD:{
               sessionTask = [_sessionManager HEAD:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:nil task:task  success:success];

               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
               }];
               
           }
               break;
           case BLYHttpRequestMethodPOST:{
               sessionTask = [_sessionManager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:responseObject task:task  success:success];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
               }];
           }
               break;
           case BLYHttpRequestMethodPUT:{
               sessionTask = [_sessionManager PUT:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:responseObject task:task  success:success];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
               }];
           }
               break;
           case BLYHttpRequestMethodPATCH:{
               sessionTask = [_sessionManager PATCH:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:responseObject task:task  success:success];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
               }];
           }
               break;
           case BLYHttpRequestMethodDELETE:{
               sessionTask = [_sessionManager DELETE:URLString parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   [self successOperarionWithUrl:URLString parameters:parameters responseObject:responseObject task:task  success:success];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   [self failureOperarionWithUrl:URLString parameters:parameters error:error task:task failure:failure];
               }];
           }
               break;
               
           default:
               return nil;
               break;
       }
       // 添加最新的sessionTask到数组
       !sessionTask ?: [[self allSessionTask] addObject:sessionTask];
       return sessionTask;
}
/// 请求成功结果处理
+ (void)successOperarionWithUrl:(NSString *)URLString
                     parameters:(id)parameters
                 responseObject:(id)responseObject
                           task:(NSURLSessionDataTask *)task
                        success:(BLYHttpRequestSuccess)success{
    [[self allSessionTask] removeObject:task];
    !success ?: success(responseObject);
}
/// 请求失败结果处理
+ (void)failureOperarionWithUrl:(NSString *)URLString
                     parameters:(id)parameters
                          error:(NSError *)error
                           task:(NSURLSessionDataTask *)task
                        failure:(BLYHttpRequestFailure)failure
{
    [[self allSessionTask] removeObject:task];
    !failure ?: failure(error);
}
#pragma mark - 统一设置请求头
+ (NSMutableDictionary *)httpHeaders
{
    NSMutableDictionary *httpHeaders = [NSMutableDictionary dictionary];
    //设置token
    if (ObjectForKey(kBLYLoginTokenKey)) {
        httpHeaders[@"token"] = ObjectForKey(kBLYLoginTokenKey);
    }
    
    //设置User-Agent
    if (ObjectForKey(kBLYUserAgentKey)) {
        httpHeaders[@"User-Agent"] = ObjectForKey(kBLYUserAgentKey);
    }
    
    //设置位置信息
    if (ObjectForKey(kBLYLocationInfoKey)) {
        httpHeaders[@"geo"] = ObjectForKey(kBLYLocationInfoKey);
    }
    
    //设置设备deviceToken
    if (ObjectForKey(kBLYDeviceTokenKey)) {
        httpHeaders[@"subscriberId"] = ObjectForKey(kBLYDeviceTokenKey);
    }
    
    //设置IDFA
    httpHeaders[@"device_token"] = [BLYGetEquipmentInfo IDFA];
    
    //设置version
    httpHeaders[@"version"] = [BLYGetEquipmentInfo appVersion];
    
    //设置platform
    httpHeaders[@"platform"] = @"iOS";
    
    //设置手机系统版本
    httpHeaders[@"platformVersion"] = [BLYGetEquipmentInfo systemVersion];
    
    //设置手机型号
    httpHeaders[@"deviceModel"] = [BLYGetEquipmentInfo iphoneType];
    
    //设置手机容量
    httpHeaders[@"diskSpaceType"] = [BLYGetEquipmentInfo diskSpaceType];
    
    //设置访问时间
    httpHeaders[@"mobile-time"] = [BLYGetEquipmentInfo currentTime];
    
    // 加密验证
    httpHeaders[@"hq_phone"] = @"true";
    httpHeaders[@"csrf_time"] = [BLYGetEquipmentInfo currentTime];
    httpHeaders[@"md5str"] = [BLYGetEquipmentInfo MD5ForLower16Bate:ContactStr(kSecretKeyForCSRF, [BLYGetEquipmentInfo currentTime])];
    return httpHeaders;
}

+ (void)setObject:(nullable id)value forKey:(nullable NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

+ (void)saveBool:(BOOL)value forKey:(nullable NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [NSMutableArray array];
    }
    return _allSessionTask;
}
#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

/**
 *  下载Manager
 */
+ (AFHTTPSessionManager *)downLoadManager
{
    if (!_downLoadManager) {
        _downLoadManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"kBLYBackgroundDownLoadIdentifier"]];
        _downLoadManager.requestSerializer.timeoutInterval = 45.f;
        _downLoadManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    }
    return _downLoadManager;
}

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize
{
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 45.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager
{
    !sessionManager ?: sessionManager(_sessionManager);
}

+ (void)setRequestSerializer:(BLYRequestSerializer)requestSerializer
{
    _sessionManager.requestSerializer = requestSerializer == BLYRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(BLYResponseSerializer)responseSerializer
{
    _sessionManager.responseSerializer = responseSerializer == BLYResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time
{
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)setHTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields
{
    [HTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull field, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
    }];
}

+ (void)openNetworkActivityIndicator:(BOOL)open
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName
{
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}


@end
