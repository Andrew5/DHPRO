//
//  LilyServerTypeManger.m
//  LilyOnlineeducation
//
//  Created by Lilyzyf on 2020/7/12.
//  Copyright © 2020 Lilyenglish. All rights reserved.
//

#import "LilyServerTypeManger.h"

/**
 存储服务器环境key
 */
#define key_LilyServerType    @"key_LilyServerType"

@implementation LilyServerTypeManger
/**
 *  设置服务器环境类型
 */
+ (void)setServerType:(LilyServerType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:key_LilyServerType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取服务器类型
 */
+ (LilyServerType)getServerType {
    LilyServerType type = [[NSUserDefaults standardUserDefaults] integerForKey:key_LilyServerType];
    if (type == 0) {
        return SERVER_TYPE_DEFAULT;
    }
    return type;
}

/**
 *  获取服务器地址.https
 */
+ (NSString *)server {
    LilyServerType type = [self getServerType];
    switch (type) {
        case LilyServerTypeLocation:
        {
            //本地联调时改变成相应的联调地址:
            return @"http://192.168.210.86:8080/";
        }
            break;
        case LilyServerTypeDevelop:
        {
            return @"http://devservice.lilyclass.com/";
        }
            break;
        case LilyServerTypeTest:
        {
            return @"https://sitservice.lilyclass.com/";
        }
            break;
        case LilyServerTypePreRelease:
        {
            return @"https://preservice.lilyclass.com/";
        }
            break;
        case LilyServerTypeProduction:
        {
            return @"https://service.lilyclass.com/";
        }
            break;
        default:
            break;
    }
    return @"";
}

/**
 *  服务器类型对应的环境名称
 */
+ (NSString *)stringForServerType {
    LilyServerType type = [self getServerType];
    NSDictionary *items =
    @{
        @(LilyServerTypeLocation) : @"本地环境",
        @(LilyServerTypeDevelop) : @"开发环境",
        @(LilyServerTypeTest) : @"测试环境",
        @(LilyServerTypePreRelease) : @"预发布环境",
        @(LilyServerTypeProduction) : @"正式环境"
    };
    return [items objectForKey:@(type)];
}
@end
