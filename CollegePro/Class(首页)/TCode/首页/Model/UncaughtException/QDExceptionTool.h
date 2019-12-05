//
//  QDExceptionTool.h
//  UncaughtExceptionHandler
//
//  Created by jabraknight on 19/9/20.
//  Copyright © 2019年 Cocoa with Love. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDExceptionTool : NSObject


+ (instancetype)shareExceptionTool;

- (void)storeExceptionWithExceptionDictionary:(NSDictionary *)dictionary;

- (void)deleteException;

+ (void)saveCreash:(NSString *)exceptionInfo;

- (NSMutableArray *)getExceptionArray;

@end
