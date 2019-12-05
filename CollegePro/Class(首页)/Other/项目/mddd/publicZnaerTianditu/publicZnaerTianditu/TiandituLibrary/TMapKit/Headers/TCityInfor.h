//
//  TCityInfor.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-12.
//  Copyright 2012 Tianditu Inc All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 下载状态
typedef enum {
    TCityMapStatusNone = 0,     ///<0没有下载
    TCityMapStatusDownLoading,  ///<1下载中
    TCityMapStatusDownLoaded,   ///<2下载完成
    TCityMapStatusUpdate,       ///<3有更新

} TCityMapStatus;


@class TCityInforInternal;

/// 城市列表中城市的信息
@interface TCityInfor : NSObject {
@private
    TCityInforInternal *_internal;
}

/// 城市名称
@property(nonatomic, readonly) NSString *strcityName;
/// 地图显示级别
@property(nonatomic, readonly) int ileveal;
/// 地图中心点
@property(nonatomic, readonly) CLLocationCoordinate2D mapcenter;

/// 矢量地图路径
@property(nonatomic, readonly) NSString *strVectMapUrl;
/// 矢量地图大小
@property(nonatomic, readonly) int iVectMapSize;
/// 矢量地图下载状态
@property(nonatomic, readonly) TCityMapStatus imapVerstatus;

/// 影像地图路径
@property(nonatomic, readonly) NSString *strImageMapUrl;
/// 影像地图大小
@property(nonatomic, readonly) int iImageMapSize;
/// 影像地图下载状态
@property(nonatomic, readonly) TCityMapStatus imapImageStatus;

@end

/// 城市列表中省信息
@interface TProvinceInfor : NSObject {
    NSString *strcityName;
    /// 省下面的城市名称
    NSMutableArray *arrCitys;
}
/// 省的名称
@property(nonatomic, readonly) NSString *strcityName;
/// 省下面的城市名称
@property(nonatomic, readonly) NSMutableArray *arrCitys;

@end

/// 已下载地图记录
@interface TDownedMap : NSObject {
@private
    void *pNatival;
}
/// 地图城市名
@property(nonatomic, readonly) NSString *strMapName;
/// 0 是矢量地图,1是影像地图
@property(nonatomic, readonly) int iMapType;
/// 地图大小
@property(nonatomic, readonly) int iMapSize;
/// 地图文件名
@property(nonatomic, readonly) NSString *strMapPath;
/// 地图中心点
@property(nonatomic, readonly) CLLocationCoordinate2D mapcenter;

@end
