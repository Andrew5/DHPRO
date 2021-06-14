//
//  UIImage+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+MJ.h"

@implementation UIImage (MJ)

+ (UIImage *)originalImageWithName:(NSString *)name
{
//    if (iOS7) {
        return [[self imageWithName:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    } else {
//        return [self imageWithName:name];
//    }
}


+ (UIImage *)imageWithName:(NSString *)name
{
//    if (iOS7) {
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        UIImage *image = [UIImage imageNamed:newName];
//        if (image == nil) { // 没有_os7后缀的图片
//            image = [UIImage imageNamed:name];
//        }
//        return image;
//    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
@end
