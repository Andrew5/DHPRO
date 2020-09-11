//
//  UIImage+compressIMG.h
//  AFNetWorking再封装
//
//  Created by 邵峰 on 17/4/11.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import <UIKit/UIKit.h>
//gradientType 渐变方向 0从上到下 1从左到右
typedef NS_ENUM(NSInteger, GradientType) {
    GradientTypeTopToBottom,
    GradientTypeLeftToRight
};
@interface UIImage (compressIMG)
+ (UIImage *)imageWithFrame:(CGRect)frame backGroundColor:(UIColor *)backGroundColor text:(NSString *)text textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;

+ (UIImage *)getGradientImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
/**
 *  图片的压缩方法
 *
 *  @param sourceImg   要被压缩的图片
 *  @param defineWidth 要被压缩的尺寸(宽)
 *
 *  @return 被压缩的图片
 */
+(UIImage *)IMGCompressed:(UIImage *)sourceImg targetWidth:(CGFloat)defineWidth;
/**
 这是一个类方法，最终返回的是一个UIImage的类
 方法中originalImage参数指的是从照片库或者拍照后选中的照片(可能是经过系统裁剪的)；
 方法中borderWidth参数指的是最终显示的圆形图像的边框的宽度，可以可以根据自己的需要设置宽度；
 方法中的borderColor参数指的是最终显示的圆形图像的边框的颜色，可以可以根据自己的需要设置颜色。
 */
+ (instancetype)circleOldImage:(UIImage *)originalImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+(UIImage *)compressImageWith:(UIImage *)image;

-(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
