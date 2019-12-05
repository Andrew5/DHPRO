//
//  WebServiceRequest.h
//  PalmDatabase
//
//  Created by 李世洋 on 16/1/7.
//  Copyright © 2016年 李世洋. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WebServiceRequest : NSObject
//+ (WebServiceRequest *)shareInstance;

+ (void)requestWithParm:(NSArray *)parm URL:(NSString *)URL requestMethod:(NSString *)requestMethod success:(void(^)(id result))block failed:(void(^)(id error))fblock hud:(BOOL)hud;
@end
