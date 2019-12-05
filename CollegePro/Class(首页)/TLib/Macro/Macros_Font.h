//
//  Macros_Font.h
//  baiduMap
//
//  Created by Mike on 16/3/29.
//  Copyright © 2016年 Mike. All rights reserved.
//

#ifndef Macros_Font_h
#define Macros_Font_h

/**
 *  字体一共有五种字号，自己需要那种使用哪种
 */
#define FONT_20 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:20] : [UIFont systemFontOfSize:15]

#define FONT_18 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:14]

#define FONT_16 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:16] : [UIFont systemFontOfSize:13]

#define FONT_15 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:15] : [UIFont systemFontOfSize:12]

#define FONT_14 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:14] : [UIFont systemFontOfSize:11]

#define FONT_13 [UIScreen mainScreen].bounds.size.width > 320 ? [UIFont systemFontOfSize:13] : [UIFont systemFontOfSize:10]


#endif /* Macros_Font_h */
