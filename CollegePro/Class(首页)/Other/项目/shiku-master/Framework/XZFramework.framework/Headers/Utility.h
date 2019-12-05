//
//  Utility.h
//  btc
//
//  Created by txj on 15/1/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#ifndef btc_Utility_h
#define btc_Utility_h
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
