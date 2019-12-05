//
//  XFAssetsLibraryModel.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;

@interface XFAssetsLibraryModel : NSObject

@property (strong, nonatomic) ALAssetsGroup *group;
/**
 *  左边的的相册首张照片
 */
@property (strong, nonatomic) UIImage *image;
/**
 *  分组名称
 */
@property (strong, nonatomic) NSString *groupName;
/**
 *  分组照片数量
 */
@property (strong, nonatomic) NSString *photosNumber;

@property (assign, nonatomic) NSInteger groupPropertyType;

+ (XFAssetsLibraryModel *)getModelWithData:(ALAssetsGroup *)data;

@end
