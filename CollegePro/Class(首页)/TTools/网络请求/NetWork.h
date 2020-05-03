//
//  NetWork.h
//  RDpublicHealth
//
//  Created by rmbp840 on 16/7/5.
//  Copyright © 2016年 rmbp840. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface NetWork : NSObject
//__nullable表示对象可以是NULL或nil，而__nonnull表示对象不应该为空
NS_ASSUME_NONNULL_BEGIN
+ (void)GETWithUrl:(NSString *__nonnull)url parameters:(NSDictionary *__nullable)parameters view:(UIView *__nullable)view ifMBP:(BOOL)mark success:(void(^)(id responseObject))success fail:(void(^)(id))fail;

+ (void)POSTWithUrl:(NSString *__nullable)url
         parameters:(NSDictionary *)parameters
               view:(UIView *__nullable)view  ifMBP:(BOOL)mark
            success:(void(^_Nullable)(id responseObject))success
               fail:(void(^_Nonnull)(NSError * _Nonnull error))fail;
NS_ASSUME_NONNULL_END
@end
