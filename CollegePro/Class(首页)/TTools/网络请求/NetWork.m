//
//  NetWork.m
//  RDpublicHealth
//
//  Created by rmbp840 on 16/7/5.
//  Copyright © 2016年 rmbp840. All rights reserved.
//

#import "NetWork.h"

@implementation NetWork
+ (void)GETWithUrl:(NSString *__nonnull)url parameters:(NSDictionary *__nullable)parameters view:(UIView *__nullable)view ifMBP:(BOOL)mark success:(void(^)(id responseObject))success fail:(void(^)(id))fail{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <=0) {
            MBProgressHUD *mb1 = [MBProgressHUD showHUDAddedTo:view animated:YES];
            mb1.mode = MBProgressHUDModeText;
            mb1.labelText = @"请检查网络连接";
            [mb1 hide:YES afterDelay:1];
        }
        else{
            if (mark == YES) {
                MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:view animated:YES];
                mb.mode = MBProgressHUDModeIndeterminate;
                mb.labelText = @"数据加载中...";
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.requestSerializer.timeoutInterval = 30.0f;
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
                [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (responseObject) {
                        
                        [mb removeFromSuperview];
                        if (success) {
                            success(responseObject);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    mb.mode = MBProgressHUDModeText;
                    mb.labelText = @"数据请求失败";
                    [mb hide:YES afterDelay:1];
                        if (fail) {
                            fail(error);
                        }
                        NSLog(@"<<<%@",error);
                }];
            }else{
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.requestSerializer.timeoutInterval = 30.0f;
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
                [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    if (responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (fail) {
                        fail(error);
                    }
                    NSLog(@">>>%@",error);
                    
                }];
            }
        }
    }];
}

+ (void)POSTWithUrl:(NSString *__nullable)url parameters:(NSDictionary *)parameters view:(UIView *__nullable)view  ifMBP:(BOOL)mark success:(void(^)(id responseObject))success fail:(void(^)(NSError * _Nonnull error))fail{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <=0) {
            MBProgressHUD *mb1 = [MBProgressHUD showHUDAddedTo:view animated:YES];
            mb1.mode = MBProgressHUDModeText;
            mb1.labelText = @"请检查网络连接";
            [mb1 hide:YES afterDelay:1];
        }
        else{
            if (mark == YES) {
                MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:view animated:YES];
                mb.mode = MBProgressHUDModeIndeterminate;
                mb.labelText = @"数据加载中...";
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
//                manager.requestSerializer= [AFJSONRequestSerializer serializer];
                manager.requestSerializer.timeoutInterval = 30.0f;
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
                [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (responseObject) {
                        [mb removeFromSuperview];
                        if (success) {
                            success(responseObject);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    mb.mode = MBProgressHUDModeText;
                    mb.labelText = @"数据请求失败";
                    [mb hide:YES afterDelay:1];
                    if (fail) {
                        fail(error);
                    }
                    NSLog(@"==%@",error);
                }];
            }
            else{
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.requestSerializer.timeoutInterval = 30.0f;
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
                [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (responseObject) {
                        if (success) {
                            success(responseObject);
                        }
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (fail) {
                        fail(error);
                    }
                    NSLog(@"---%@",error);
                }];
            }
        }
    }];
}
@end
