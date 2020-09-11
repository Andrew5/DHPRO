//
//  BookDataViewModel.m
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "BookDataViewModel.h"
#import "NetWork.h"

@implementation BookDataViewModel

+(void)syncMethod:(DHNetworkResponseObjectCompletion)completion{
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",@"beijing"];
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [NetWork GETWithUrl:url parameters:nil view:nil ifMBP:NO success:^(id  _Nonnull responseObject) {
        NSLog(@"请求-1-%@--",responseObject);
        if (completion) {
            completion(responseObject,nil);
        }
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"请求-1---");
    }];
}
+(void)bookDataRequestOncompletion:(DHNetworkResponseResultCompletion)completion{
    NSDictionary *parameters;
    parameters = @{@"Url":@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx",
                   @"MethodType":@"GET",
                   @"Value":@"?json=GetUserInfoAll&UserID=2"
    };
    [NetWork POSTWithUrl:@"https://www.homesoft.cn/WebInterface/HBInterface.ashx" parameters:parameters view:nil ifMBP:NO success:^(id responseObject) {
        NSLog(@"请求-2-%@--",responseObject[@"UserInfo"]);
        if (completion) {
            completion(responseObject[@"UserInfo"]);
        }
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"请求-2---");
    }];;
}
+ (void)add:(DHNetworkResponseObjectCompletion)completion{
    AFHTTPSessionManager *manager;
    manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",@"北京"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *resultArray = responseObject[@"results"];
//    }];
}
@end
