//
//  ZTHttpRequestServer.m
//  ZinTaoSellerAPP
//
//  Created by hupeng on 16/6/14.
//  Copyright © 2016年 cherrySmart. All rights reserved.
//

#import "ECHttpRequestServer.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>



@implementation ECHttpRequestServer


/*sharedClient*/
+ (instancetype)sharedClient {
    
    static ECHttpRequestServer *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ECHttpRequestServer alloc] initWithBaseURL:[NSURL URLWithString:@"http://kaifa.homesoft.cn/"]];//Server_IP
//        sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        sharedClient.requestSerializer.timeoutInterval = 10;
        sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    });
    return sharedClient;
}

/*取消请求*/
-(void)cancelRequest{
    [self.theTask cancel];
}

/**
 @brief 请求url打印
 */
- (void)logRequestURLWithPath:(NSString *)path paramters:(NSDictionary *)parameters{
    NSString *url = [self.baseURL absoluteString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    url = [url stringByAppendingFormat:@"%@?p=%@", path, jsonString];
    NSLog(@"打印接口请求URL: %@", url);
    
}


/**
 *  封装的POST请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (NSURLSessionDataTask *)PostZT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(_Nullable Success)success failure:(_Nullable Failure)failure{
    
    if(parameters == nil){
        parameters =[NSDictionary dictionary];
    }

#ifdef DEBUG
    [self logRequestURLWithPath:URLString paramters:parameters];
#endif
    NSMutableDictionary *tempDic =[NSMutableDictionary dictionaryWithDictionary:parameters];


    _theTask = [super POST:URLString parameters:tempDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *status =[responseObject objectForKey:@"status"];
        if([status integerValue] == -1){
        }
        if (success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err:%@",error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (failure){
            NSError *error = [NSError errorWithDomain:@"网络异常" code:500 userInfo:nil];
            failure(error);
        }
    }];
    return _theTask;

}




/**
 *  封装的GET请求
 *
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
- (void)GetZT:(NSString *)URLString parameters:(NSDictionary *)parameters success:(_Nullable Success)success failure:(_Nullable Failure)failure{
    if(parameters == nil){
        parameters =[NSDictionary dictionary];
    }
#ifdef DEBUG
    [self logRequestURLWithPath:URLString paramters:parameters];
#endif
   _theTask = [super GET:URLString parameters:parameters headers:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success){
            
            NSString *status =[responseObject objectForKey:@"status"];
            if([status integerValue] == -1){
            }
            if(success){
                success(responseObject);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure){
            NSError *error = [NSError errorWithDomain:@"网络异常" code:500 userInfo:nil];
            failure(error);
        }
    }];
}



/**
 *  上传图片
 *  @param image  图片
 *  @param URLString  请求的链接
 *  @param parameters 请求的参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */

-(void)UploadImage:(NSString *)URLString image:(UIImage *)image parameters:(NSDictionary *)parameters success:(_Nullable Success)success failure:(_Nullable Failure)failure{
    if(parameters == nil){
        parameters =[NSDictionary dictionary];
    }
    
#ifdef DEBUG
    [self logRequestURLWithPath:URLString paramters:parameters];
#endif
    
    _theTask= [super POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSMutableString * str_name = nil;
        NSMutableString * str_name_png = nil;
        NSData * data = UIImageJPEGRepresentation(image, 1.0f);
        
        str_name = [NSMutableString stringWithFormat:@"photo"];
        str_name_png = [NSMutableString stringWithFormat:@"photo.png"];
        [formData appendPartWithFileData:data
                                    name:str_name
                                fileName:str_name_png
                                mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success){
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure){
            failure(error);
        }
    }];

}




@end
