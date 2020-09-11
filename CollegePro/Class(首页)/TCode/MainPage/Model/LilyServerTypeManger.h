//
//  LilyServerTypeManger.h
//  LilyOnlineeducation
//
//  Created by Lilyzyf on 2020/7/12.
//  Copyright © 2020 Lilyenglish. All rights reserved.
//
//服务器环境切换控制类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///pch
typedef NS_ENUM(NSUInteger, LilyServerType) {
    /// 本地环境
    LilyServerTypeLocation = 1,
    /// 开发环境
    LilyServerTypeDevelop,
    /// 测试环境
    LilyServerTypeTest,
    /// 预发布环境
    LilyServerTypePreRelease,
    /// 正式环境,上线环境
    LilyServerTypeProduction,
};
#pragma mark - 服务器配置
/// 给测试和接口人员切换服务器环境设置为YES，上线打包设置为NO
#define ServerManageEnable NO
/// 配置默认的服务器环境，上线打包为正式环境:LilyServerTypeProduction
static LilyServerType SERVER_TYPE_DEFAULT = LilyServerTypeProduction;
/// 服务器地址
#define  URLHOST [LilyServerTypeManger server]
///pch

@interface LilyServerTypeManger : NSObject

/**
 *  设置服务器环境类型
 */
+ (void)setServerType:(LilyServerType)type;

/**
 *  获取服务器类型
 */
+ (LilyServerType)getServerType;

/**
 *  获取服务器地址.https
 */
+ (NSString *)server;

/**
 *  服务器类型对应的环境名称
 */
+ (NSString *)stringForServerType;
@end

NS_ASSUME_NONNULL_END
