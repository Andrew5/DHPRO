//
//  BackendAssembler.h
//  btc
//
//  Created by txj on 15/1/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseResult.h"

@interface BackendAssembler : NSObject
//解析错误内容
- (NSError *)error:(NSDictionary *)JSON;
- (NSString *)digitalWithString:(NSString *)string;
//返回
-(ResponseResult *)responseResult:(NSDictionary *)responseObject;
//解析分页
-(PAGINATION *)pagination:(NSDictionary *)paginationJson;
//分页对象转json字符串
-(NSMutableDictionary *)paginationToJsonObject:(PAGINATION *)pagination;
@end
