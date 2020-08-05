//
//  WKHeader.h
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#ifndef WKHeader_h
#define WKHeader_h
#define WK_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define WK_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define WK_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define WK_SCREEN_MAX_LENGTH (MAX(WK_SCREEN_WIDTH, WK_SCREEN_HEIGHT))
#define WK_IS_IPHONE_X (WK_IS_IPHONE && WK_SCREEN_MAX_LENGTH == 812.0)
#define WK_NAVIGATION_STATUS_HEIGHT (WK_IS_IPHONE_X ? 88.f : 64.f)

#endif /* WKHeader_h */
