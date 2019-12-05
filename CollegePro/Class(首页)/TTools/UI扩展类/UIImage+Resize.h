//
//  UIImage+Resize.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/13.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 截取图片上指定尺寸内容
 
 @param bounds 指定尺寸
 @return 截取后的皂片
 */
- (UIImage *)croppedImage:(CGRect)bounds;

/**
 同上 可以的改变图片方向
 
 @param bounds同上
 @param orientation 照片方向枚举
 @return 同上
 */
- (UIImage *)croppedImage:(CGRect)bounds
          WithOrientation:(UIImageOrientation)orientation;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)fixOrientation;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

/**
 截取当前view生成image

 @param theView 需要截取的view
 */
+ (UIImage *)croppedImageFromView:(UIView *)theView;

/**
 根据当前图片方向和设备方向来旋转照片
 */
- (UIImage *)changeImageWithOrientation:(UIDeviceOrientation)deviceOrientation;
@end
