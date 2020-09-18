//
//  UIApplication+scanLocalVideo.h
//  LocalVideo

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger , TFVideoAssetType){
    
    TFVideoAssetTypeVideoImageSource, //视频缩略图
    TFVideoAssetTypeVideoTimeLength,  //视频时长
    TFVideoAssetTypeVideoName,        //视频名称
    TFVideoAssetTypeVideoSize        //视频大小
};

@interface UIApplication (scanLocalVideo)

/**
 *  获取相册的授权
 *  @return YES/NO
 */
- (BOOL)authStatus;

/**
 *  视频的搜索结果
 *
 *  @return 返回的是一个数组集合，里面是PHAsset
 */
- (PHFetchResult *)assetsFetchResults;

/**
 *  获取所需要的Video属性
 *
 *  @param type TFVideoAssetType
 *
 *  @return 资源数组
 */
- (NSArray *)getVideoRelatedAttributesArray:(TFVideoAssetType)type;

//获取文件大小
-(void)getVideoFileSize:(PHAsset *)asset getFileSize:(void(^)(NSString * size,NSData * data))getFileSize;

//获取文件路径
-(void)getCopyVideoFilepath:(PHAsset *)asset getFilePath:(void(^)(NSString * path))getFilePath;

//获取图片数据
-(void)getImageFileData:(PHAsset *)asset ImageData:(void(^)(UIImage * img))ImageData;

//获取图片data
-(void)getDataImageFileWithAsset:(PHAsset *)asset ImageData:(void(^)(NSData * imgData))ImageData;

@end
