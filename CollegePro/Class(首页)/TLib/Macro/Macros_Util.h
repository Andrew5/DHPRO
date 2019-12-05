//
//  Macros_Utils.h
//  baiduMap
//
//  Created by Mike on 16/3/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_Utils_h
#define Macros_Utils_h

// Thread
#define MKAssertMainThread() NSAssert([NSThread isMainThread], @"这个方法必须在主线程调用");
#define MKAssertOtherThread() NSAssert(![NSThread isMainThread], @"这个方法必须在子线程调用");

// KVO KVC
#define keyPath(obj, attr) @(((void)obj.attr, #attr))
#define keyPathWithSELName(sltName) NSStringFromSelector(@selector(sltName)) // property/selectorName -> keyPath

// NSLog
#if defined(DEBUG) || defined(_DEBUG)
#define NSLog(format, ...) \
    do {\
        fprintf(stderr, "<%s : %d> %s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __func__); \
        (NSLog)((format), ##__VA_ARGS__); \
        fprintf(stderr, "-------\n"); \
    } while (0)
#else
#define NSLog(...)
#endif

// iOS 版本
#define MKSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER MKSystemVersionGreaterOrEqualThan(7.0)
#define IOS8_OR_LATER MKSystemVersionGreaterOrEqualThan(8.0)
#define IOS9_OR_LATER MKSystemVersionGreaterOrEqualThan(9.0)
#define IOS8_1_OR_LATER MKSystemVersionGreaterOrEqualThan(8.1)
#define MKSystemVersionLowerOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] < version)
#define IOS6_EARLY MKSystemVersionLowerOrEqualThan(6.0)

// safe access
#define isNilOrNull(obj) (obj == nil || [obj isEqual:[NSNull null]])
#define isClassEqualNil(clazz) (clazz == Nil)
#define NULL_POINTER NULL

// bundle
#define DOCUMENT_FOLDER ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
#define bundlePathWithName(name) [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name]
#define bundleWithName(name) [NSBundle bundleWithPath:bundlePathWithName(name)]

// 判断string是否为空 nil 或者 @""；
#define IsNilString(__String) (__String==nil || [__String isEqualToString:@""] || [[__String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])


#endif /* Macros_Utils_h */
