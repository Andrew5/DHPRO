//
//  XFAssetsModel.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
/**
 *  图片Model
 */
@interface XFAssetsModel : NSObject
/**
 *  用asset的date做唯一标识
 */
@property (copy, nonatomic) NSString *modelID;
/**
 *  原始数据
 */
@property (strong, nonatomic) ALAsset *asset;
/**
 *  缩略图
 */
@property (strong, nonatomic) UIImage *thumbnailImage;
/**
 *  是否是选中状态
 */
@property (assign, nonatomic) BOOL selected;

/**
 valueForProperty的属性值无效将返回：ALErrorInvalidProperty
 资源类别:ALAssetPropertyType//有三种资源类别：ALAssetTypePhoto(图片), ALAssetTypeVideo(视频),ALAssetTypeUnknown(未知)
 资源拍摄地点:ALAssetPropertyLocation
 资源视频持续时间:ALAssetPropertyDuration
 资源方向:ALAssetPropertyOrientation//值为枚举类型：ALAssetOrientation
 资源创建时间:ALAssetPropertyDate
 资源UTI数组:ALAssetPropertyRepresentations
 资源URL:ALAssetPropertyAssetURL
 资源key-value集合:ALAssetPropertyURLs//key:为uti；value:为url
 */
+ (XFAssetsModel *)getModelWithData:(ALAsset *)asset;

@end
