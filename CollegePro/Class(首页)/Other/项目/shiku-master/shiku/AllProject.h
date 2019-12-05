//
//  AllProject.h
//  TopUTest
//
//  Created by 会飞的鱼 on 14-9-22.
//  Copyright (c) 2014年 会飞的鱼. All rights reserved.
//
#ifndef youcai_AllProject_h
#define youcai_AllProject_h



//AppStore上的id
#define APPID @"1003660613"

#define SCREEM_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEM_H ([UIScreen mainScreen].bounds.size.height)

#define W_RATE_IPHOEN5 ([UIScreen mainScreen].bounds.size.width/320)
#define H_RATE_IPHOEN5 ([UIScreen mainScreen].bounds.size.height/568)

#define PERSON_INFO [PersonInfo sharePersionInfo]

//颜色
#define GREEN [UIColor colorWithHex:0x4cb228]
#define BLUE  [UIColor colorWithHex:0x0b6ff8]
#define RED   [UIColor colorWithHex:0xd80001]
#define LIGHT_GRAY [UIColor colorWithHex:0xDBDBDB]

//日期格式话
#define FullDateFormat @"yyyy-MM-dd HH:mm:ss"
#define FullDayFormat @"yyyy-MM-dd"

//状态条的高
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//得到屏幕bounds
#define MainScreenSize [UIScreen mainScreen].bounds

//得到屏幕高度
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

//得到屏幕宽度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

//定义系统版本
#define SysVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//app版本
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define IPHONE_4 [UIScreen mainScreen].bounds.size.height==480

#define IPHONE_5 [UIScreen mainScreen].bounds.size.height==568

#define IPHONE_6 [UIScreen mainScreen].bounds.size.height==667

#define IPHONE_6P [UIScreen mainScreen].bounds.size.height==736



#endif