//
//  PHAsset+Method.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/9.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (Method)

/**
 获取相册最近的一张照片
 */
+ (PHAsset *)latestAsset;
@end
