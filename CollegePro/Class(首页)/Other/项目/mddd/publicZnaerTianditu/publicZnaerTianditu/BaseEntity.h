//
//  BaseEntity.h
//  ZLYDoc
//
//  Created by Ryan on 14-4-3.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SUCCESS 0

typedef enum {
    SEXWOMAN = 0,
    SEXMAN = 1
}Gender;

@interface BaseEntity : NSObject


@property (nonatomic,copy) NSString *_id;//ID
@property (nonatomic     ) int      status;//登录注册状态
@property (nonatomic     ) NSString *msg;//状态信息
@property (nonatomic     ) NSString *version;//版本号
@property (nonatomic     ) NSString *updateURL;//升级URL
@property (nonatomic     ) int      code;//其他请求状态
@property (nonatomic     ) NSString *des;//错误信息描述


/**
 *  解析HTTP返回异常JSON
 *
 *  @param json
 *
 *  @return 
 */
+ (BaseEntity *)parseResponseErrorJSON:(id)json;

/**
 *  解析成功或失败状态JSON
 *
 *  @param json
 *
 *  @return 
 */
+ (BaseEntity *)parseResponseStatusJSON:(id)json;

/**
 *  解析版本号及升级URL JSON
 *
 *  @param json
 *
 *  @return 
 */
+ (BaseEntity *)parseResponseUpdateJSON:(id)json;




@end
