//
//  XFHUD.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/6.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFHUD : NSObject

+ (void)showWithContent:(NSString *)test;

+ (void)showInOpenLibary;

+ (void)overMaxNumberWithNumber:(NSInteger)number;

+ (void)dismiss;

@end
