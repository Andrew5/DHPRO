//
//  TDownLoadingCity.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-12.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCityInfor.h"

/// 下载状态
typedef enum {
    TDownLoadingStatusWait = 0,     ///<0等待下载
    TDownLoadingStatusLoading,      ///<1正在下载
    TDownLoadingStatusPause,        ///<2暂停下载

} TDownLoadingStatus;

/// 下载地图类型
typedef enum {
    TDownLoadingTypeVect,           ///<0矢量地图
    TDownLoadingTypeImage,          ///<1影像地图

} TDownLoadingType;

/// 正在下载的城市信息
@interface TDownLoadingCity : NSObject {
    void *_internal;
    NSString *strFileName;
    TDownLoadingStatus istatus;
    int iIndexOfcityList;
}
/// 下载信息记录文件路径
@property(nonatomic, retain, readonly) NSString *strFileName;
/// 0,等待下载,1正在下载 ,2暂停下载
@property(nonatomic, assign, readonly) TDownLoadingStatus istatus;
/// 在城市列表的第几个
@property(nonatomic, assign, readonly) int iIndexOfcityList;
/// 城市名称
@property(nonatomic, assign, readonly) NSString *strName;

/// 文件类型
@property(nonatomic, readonly) TDownLoadingType ltype;
/// 下载地址
@property(nonatomic, readonly) NSString *strUrl;
/// 文件大小
@property(nonatomic, readonly) int ltotalsize;
/// 下载大小
@property(nonatomic, readonly) int lDownSize;

/**
 * 用下载链接初始化
 * @param cityinfor [in] : 城市信息
 * @param iMaptype [in] : 0 是矢量地图,1是影像地图
 */
- (id)initWithCityInfor:(TCityInfor *)cityinfor maptype:(int)iMaptype;
@end
