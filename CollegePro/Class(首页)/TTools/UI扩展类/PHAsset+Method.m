//
//  PHAsset+Method.m
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/9.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "PHAsset+Method.h"

@implementation PHAsset (Method)
+ (PHAsset *)latestAsset {
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    return [assetsFetchResults firstObject];
}
@end
