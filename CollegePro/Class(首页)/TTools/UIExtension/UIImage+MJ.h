//
//  UIImage+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MJ)
/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;
+ (UIImage *)originalImageWithName:(NSString *)name;
/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
