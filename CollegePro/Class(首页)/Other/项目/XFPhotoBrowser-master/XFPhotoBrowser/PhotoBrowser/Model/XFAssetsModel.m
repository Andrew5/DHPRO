//
//  XFAssetsModel.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsModel.h"

@implementation XFAssetsModel

+ (XFAssetsModel *)getModelWithData:(ALAsset *)data {
    return [[self alloc] changeAssetsToModelWithAsset:data];
}

- (XFAssetsModel *)changeAssetsToModelWithAsset:(ALAsset *)asset {
    XFAssetsModel *model = [[XFAssetsModel alloc] init];
    
    model.modelID = [asset valueForProperty:ALAssetPropertyURLs];
    
    model.asset = asset;
    
    model.thumbnailImage = [UIImage imageWithCGImage:asset.thumbnail];
    
//    @try {
//        if ( asset.defaultRepresentation ) {
//            if ( asset.defaultRepresentation.fullScreenImage ) {
//                model.fullScreenImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            }
//        }
//    } @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    } @finally {
//        
//    }
    
    model.selected = NO;
    
    return model;
}

@end
