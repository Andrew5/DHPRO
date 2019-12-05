//
//  HAMLogOutputWindow.h
//  HAMLogOutputWindowDemo
//
//  Created by DaiYue’s Macbook on 16/11/9.
//  Copyright © 2016年 Find the Lamp Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 [单例] 用于测试时在屏幕上输出 log 的窗口。用法：
 
 1. 初始化
 
 在 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 里添加：
 ```
 [[HAMLogOutputWindow sharedInstance] setHidden:NO];
 ```
 
 2. 输出 log
 
 ```
 [HAMLogOutputWindow printLog:(NSString*)text];
 ```
 
 3. 如需清空 log
 
 ```
 [HAMLogOutputWindow clear];
 ```

 */
@interface HAMLogOutputWindow : UIWindow

+ (instancetype)sharedInstance;

/**
 在测试窗口输出 log，结尾会自动换行。测试窗口会自动向下滚动，最新的 log 显示为黄色，旧的 log 显示为白色。

 @param text 要输出的 log。
 */
+ (void)printLog:(NSString*)text;

/**
 清空测试窗口
 */
+ (void)clear;

@end
