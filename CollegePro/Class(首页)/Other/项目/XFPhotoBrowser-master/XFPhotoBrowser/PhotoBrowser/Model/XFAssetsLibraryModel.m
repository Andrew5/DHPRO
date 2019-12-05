//
//  XFAssetsLibraryModel.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsLibraryModel.h"
#import <AssetsLibrary/ALAssetsGroup.h>

@implementation XFAssetsLibraryModel

+ (XFAssetsLibraryModel *)getModelWithData:(ALAssetsGroup *)data {
    return [[self alloc] changeAssetsGroupToModelWithAssetsGroup:data];
}

- (XFAssetsLibraryModel *)changeAssetsGroupToModelWithAssetsGroup:(ALAssetsGroup *)assetsGroup {
    XFAssetsLibraryModel *model = [[XFAssetsLibraryModel alloc] init];
    
    model.group = assetsGroup;
    
    CGImageRef imageRef = assetsGroup.posterImage;
    model.image = [UIImage imageWithCGImage:imageRef];
    
    model.groupName = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    model.photosNumber = [NSString stringWithFormat:@"%ld",(long)[assetsGroup numberOfAssets]];
    
    model.groupPropertyType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] integerValue];
    
    return model;
}

@end
