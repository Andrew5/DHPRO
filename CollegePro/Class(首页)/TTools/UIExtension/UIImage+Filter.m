//
//  UIImage+Filter.m
//  XingZhe
//
//  Created by 刘欢 on 2017/3/14.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "UIImage+Filter.h"

@implementation UIImage (Filter)
//------------滤镜--------------------\\

// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
/**对图片进行滤镜处理*/
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}
/*
 NSDictionary *filter = @{@"怀旧":@"CIPhotoEffectInstant",
 @"黑白":@"CIPhotoEffectNoir",
 @"单色":@"CIPhotoEffectMono",
 @"色调":@"CIPhotoEffectTonal",
 @"褪色":@"CIPhotoEffectFade",
 @"冲印":@"CIPhotoEffectProcess",
 @"岁月":@"CIPhotoEffectTransfer",
 @"珞璜":@"CIPhotoEffectChrome",
 @"未知1":@"CILinearToSRGBToneCurve",
 @"线性加深":@"CISRGBToneCurveToLinear",
 @"晕影":@"CIVignetteEffect"};
 */
@end
