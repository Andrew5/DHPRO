//
//  NSDate+HB.h
//  GitomBApp
//
//  Created by lsy on 14-7-5.
//  Copyright (c) 2014年 gitom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HB)
/**传入一个时间戳字符串.返回一个格式为 MM-dd HH:mm 的字符串*/
+ (NSString *)dateWithString:(NSString *)string;
+(NSString*)changeTheDateTo:(NSString*)theDate;
+(NSString*)changeTimeStrTo:(NSString*)timeStr;
+ (NSString *)dateWithString1:(NSString *)string;

@end
