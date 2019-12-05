
//
//  Macros_Color.h
//  baiduMap
//
//  Created by Mike on 16/3/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_Color_h
#define Macros_Color_h

// Method Macro
#define ColorRGB(r, g, b) ([UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f])

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

// Constants
// 主色调：绿色

/// 绿色
#define GREEN_COLOR RGBA(30, 180, 20, 1)
/// 蓝色
#define BLUE_COLOR HEXCOLOR(0x00aaff)
// RGBA(76, 135, 240, 1)

/// 紫色
#define PURPLE_COLOR RGBA(118, 87, 165, 1)
/// 红色
#define RED_COLOR RGBA(246, 63, 111, 1)
/// 青色
#define CYAN_COLOR RGBA(35, 199, 191, 1)
/// 橙色
#define ORANGE_COLOR RGBA(253, 122, 8, 1)



#endif /* Macros_Color_h */
