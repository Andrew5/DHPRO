//
//  UIImage+Filter.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/3/14.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)

/*  ------------滤镜--------------------

 @param image 源image
 @param name    怀旧 --> CIPhotoEffectInstant
                单色 --> CIPhotoEffectMono
                黑白 --> CIPhotoEffectNoir                            
                褪色 --> CIPhotoEffectFade
                色调 --> CIPhotoEffectTonal 
                冲印 --> CIPhotoEffectProcess
                岁月 --> CIPhotoEffectTransfer  
                铬黄 --> CIPhotoEffectChrome
 // CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
 @return 处理过后的image
 */
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;
@end
