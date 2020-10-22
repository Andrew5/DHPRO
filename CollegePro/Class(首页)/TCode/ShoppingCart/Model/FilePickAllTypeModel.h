//
//  FilePickAllTypeModel.h
//  JHFilePick
//
//  Created by likuan on 2018/3/20.
//  Copyright © 2018年 com.jinher.likuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger , PHDataType) {
    TypeVideoSource, //视频
    TypeAudioSource, //音频
    TypeOtherSource  //其他
};

@interface FilePickAllTypeModel : NSObject

@property (nonatomic,assign) BOOL isSelected;//是否选中

@property(nonatomic,strong) PHAsset *asset;

@property(nonatomic,assign) PHDataType Datatype; // 0 视频 1 音频 2 其他或者图片

@property(nonatomic,strong) NSString *filePath;

@property(nonatomic,strong) NSString *fileID;

@property(nonatomic,strong) UIImage *img;

@property(nonatomic,strong) NSString *fileName;

@property(nonatomic,strong) NSString *fileCreaTime;

@property(nonatomic,strong) NSString *fileSize;

@end
