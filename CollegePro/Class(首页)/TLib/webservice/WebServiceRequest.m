//
//  WebServiceRequest.m
//  PalmDatabase
//
//  Created by 李世洋 on 16/1/7.
//  Copyright © 2016年 李世洋. All rights reserved.
//

#import "WebServiceRequest.h"
#import "SoapUtil.h"
#import "XMLDictionary.h"

@implementation WebServiceRequest

static SoapUtil *_soap;

+ (void)initialize
{
    _soap = [[SoapUtil alloc] init];
}

+ (void)requestWithParm:(NSArray *)parm URL:(NSString *)URL requestMethod:(NSString *)requestMethod success:(void (^)(id))block failed:(void (^)(id))fblock hud:(BOOL)hud
{
//    if (hud) {
//          [MBProgressHUD showMessage:@""];
//    }
    NSLog(@"%@", URL);
    _soap.nameSpace = @"http://ws.yyq.com";
//    _soap.nameSpace = @"http://webservice.order.unis.com";
    _soap.endpoint = URL;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       NSLog(@"%@", parm);
                       NSData * resultData = [_soap requestMethod:requestMethod withDate:parm];
                       NSLog(@"请求完毕");
                       if (resultData)
                       {
                           NSDictionary * dict = [NSDictionary dictionaryWithXMLString:[[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding]];
                           
                           /**解析**/
//                           NSDictionary *dic1 = dict[@"soapenv:Body"];
//                           NSString *str1 = [@"ns1:"stringByAppendingString:requestMethod];
//                           NSString *str2 = [str1 stringByAppendingString:@"Response"];
//                           NSDictionary *dic3 = dic1[str2];
//                           NSString *str3 = [requestMethod stringByAppendingString:@"Return"];
//                           NSDictionary *dic4 = dic3[str3];
//                           
//                           NSString *dataStr = dic4[@"__text"];
//                           
//                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                           
                           NSLog(@"message: %@", dict);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               block(dict);
                           });
                           
                       } else {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               fblock(nil);
                           });
                           NSLog(@"下载失败, 请重试");
                       }
                   });}


@end


