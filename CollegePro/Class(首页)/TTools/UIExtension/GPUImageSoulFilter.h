//
//  GPUImageSoulFilter.h
//  LUTFilter
//
//  Created by zhuyongqing on 2017/12/21.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface GPUImageSoulFilter : GPUImageTwoInputFilter

@property(nonatomic,assign) float mix;
@property(nonatomic,assign) float scale;



@end
