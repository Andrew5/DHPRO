//
//  BLYGetEquipmentInfo.h
//  NetworkRequestDemo
//
//  Created by admin on 2020/5/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLYGetEquipmentInfo : NSObject
/// 手机型号
+ (NSString *_Nullable)iphoneType;
/// 手机容量
+ (NSString *)diskSpaceType;
/// 系统版本
+ (NSString *)systemVersion;
/// app版本
+ (NSString *)appVersion;
/// IDFA编号
+ (NSString *)IDFA;
/// 系统当前时间
+ (NSString *)currentTime;
// MD5加密
/*
 *由于MD5加密是不可逆的,多用来进行验证
 */
// 32位小写
+ (NSString *)MD5ForLower32Bate:(NSString *)str;
// 32位大写
+ (NSString *)MD5ForUpper32Bate:(NSString *)str;
// 16位小写
+ (NSString *)MD5ForLower16Bate:(NSString *)str;
// 16为大写
+ (NSString *)MD5ForUpper16Bate:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
