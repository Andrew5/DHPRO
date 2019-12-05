//
//  NSString+Hex.h
//  TuBo
//
//  Created by 杨涛 on 2017/5/18.
//  Copyright © 2017年 www.mepai.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hex)

+ (NSString *)hexStringFromData:(NSData*)data;
+ (NSInteger )hexStringFromHexData:(NSData*)data;
+ (NSData *)convertHexStrToData:(NSString *)str;

@end
