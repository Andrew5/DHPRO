//
//  CrashAvoidManager.m
//  Test
//
//  Created by Rillakkuma on 2018/7/9.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "CrashAvoidManager.h"
#import "CrashAvoidConst.h"


@implementation CrashAvoidManager


/**
 *  类方法的交换
 *
 *  @param anClass    哪个类
 *  @param method1Sel 方法1
 *  @param method2Sel 方法2
 */
+ (void)exchangeClassMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    Method method1 = class_getClassMethod(anClass, method1Sel);
    Method method2 = class_getClassMethod(anClass, method2Sel);
    method_exchangeImplementations(method1, method2);
}


/**
 *  对象方法的交换
 *
 *  @param anClass    哪个类
 *  @param method1Sel 方法1(原本的方法)
 *  @param method2Sel 方法2(要替换成的方法)
 */
+ (void)exchangeInstanceMethod:(Class)anClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    
    
    Method originalMethod = class_getInstanceMethod(anClass, method1Sel);
    Method swizzledMethod = class_getInstanceMethod(anClass, method2Sel);
    
    BOOL didAddMethod =
    class_addMethod(anClass,
                    method1Sel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(anClass,
                            method2Sel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}


/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
+ (void)noteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo
{
  
    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [CrashAvoidManager getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil) {
        
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    //errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds
    //将avoidCrash去掉
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"avoidCrash" withString:@""];
    
    NSString *errorPlace = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
    
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@",AvoidCrashSeparatorWithFlag, errorName, errorReason, errorPlace, defaultToDo];
    
    logErrorMessage = [NSString stringWithFormat:@"%@\n\n%@\n\n",logErrorMessage,AvoidCrashSeparator];
    
    
    //请忽略下面的赋值，目的只是为了能顺利上传到cocoapods
    logErrorMessage = logErrorMessage;
    
    NSDictionary *errorInfoDic = @{
                                   key_errorName        : errorName,
                                   key_errorReason      : errorReason,
                                   key_errorPlace       : errorPlace,
                                   key_defaultToDo      : defaultToDo,
                                   key_exception        : exception,
                                   key_callStackSymbols : callStackSymbolsArr
                                   };
    
    
//    NSLog(@"error == %@",errorInfoDic);
}


/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}
@end
