//
//  CustomWebViewPool.h
//  NetworkRequestDemo
//
//  Created by admin on 2020/6/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomWebViewPool : NSObject
+ (instancetype)sharedInstance;

/**
 预初始化若干WKWebView
 @param count 个数
 */
- (void)prepareWithCount:(NSUInteger)count;

/**
 从池中获取一个WKWebView
 
 @return WKWebView
 */

- (CustomWebView *)getWKWebViewFromPool;
@end

NS_ASSUME_NONNULL_END
