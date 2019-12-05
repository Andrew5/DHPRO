//
//  BaseHandler.m
//  zlydoc-iphone
//
//  Created by Ryan on 14-6-25.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "BaseHandler.h"
#import "APIConfig.h"
#import "AppDelegate.h"
#import "UserInfoStorage.h"
#import "UserEntity.h"
#import "UserManagerHandler.h"
#import "Constants.h"
@implementation BaseHandler

#define REPLACE_STR @"{token}"

+ (NSString *)requestUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@",SERVER_HOST,path];
}

+ (NSString *)requestUrlByTokenWithPath:(NSString *)path{
    path = [path stringByReplacingOccurrencesOfString:REPLACE_STR withString:TOKEN];
    return [BaseHandler requestUrlWithPath:path];
}

+ (NSString *)retImageUrl:(NSString *)imageName{
    
    return [NSString stringWithFormat:@"%@/icon/%@",SERVER_HOST,imageName];

}

@end
