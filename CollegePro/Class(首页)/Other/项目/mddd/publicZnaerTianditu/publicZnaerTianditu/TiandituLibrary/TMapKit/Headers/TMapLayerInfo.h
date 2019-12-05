//
//  TMapLayerInfo.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-19.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>

/// 标注图层信息:如 POI,水系,道路等
@interface TMapLayerInfo : NSObject {
    /// 图层的名称
    NSString *mLayerName;
    /// 图层类型
    int mType;
    /// 图层是否显示
    BOOL mbisShow;
}

/// 图层的名称
@property(nonatomic, readonly) NSString *mLayerName;
/// 图层类型
@property(nonatomic, readonly) int mType;
/// 图层是否显示
@property(nonatomic, readonly) BOOL mbisShow;
@end

/// 地图类型信息,如:矢量,影像,地形
@interface TMapInfo : NSObject {
    /// 地图类型名称(如:矢量,影像,地形)
    NSString *strMapName;
    /// 当前类型地图所有标注底图图层信息
    NSArray *arrLayerInfo;
    /// 最小比例尺
    int iMinLevel;
    /// 最大比例尺
    int iMaxLevel;
    void *pNavtive;
}
/// 地图类型名称(如:矢量,影像,地形)
@property(nonatomic, readonly) NSString *strMapName;
/// 当前类型地图所有标注底图图层信息
@property(nonatomic, readonly) NSArray *arrLayerInfo;
/// 最小比例尺
@property(nonatomic, readonly) int iMinLevel;
/// 最大比例尺
@property(nonatomic, readonly) int iMaxLevel;

/**
 * 设置图层是否可以显示
 * @param maplayer [in] : 标注图层信息
 * @param bShow  [in] : 是否显示
 */
- (void)SetMapLayer:(TMapLayerInfo *)maplayer Show:(BOOL)bShow;
@end
