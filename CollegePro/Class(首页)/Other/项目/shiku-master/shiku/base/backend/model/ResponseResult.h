//
//  ResponseResult.h
//  btc
//
//  Created by txj on 15/2/1.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  接口返回数据解析
 */
@interface ResponseResult : NSObject
//api接口请求是否成功
@property (assign, nonatomic) BOOL success;
//如果错误 错误的信息
@property (strong, nonatomic) NSString *messge;
//服务器返回的Json对象
@property (strong, nonatomic) NSDictionary *data;
//服务器返回的字符串对象
@property (strong, nonatomic) NSString *strdata;
@end
