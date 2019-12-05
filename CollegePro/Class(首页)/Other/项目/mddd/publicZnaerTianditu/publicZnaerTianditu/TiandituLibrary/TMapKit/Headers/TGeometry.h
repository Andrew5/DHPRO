//
//  TMapView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 13-6-8.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/// 经纬度范围
typedef struct {
    CLLocationDegrees latitudeDelta;    ///<纬度范围
    CLLocationDegrees longitudeDelta;   ///<经度范围
} TCoordinateSpan;

/// 经纬度区域
typedef struct {
    CLLocationCoordinate2D center;      ///<中心点经纬度坐标
    TCoordinateSpan span;               ///<经纬度范围
} TCoordinateRegion;

/**
 * 构造TCoordinateSpan
 * @param latitudeDelta     [in] : 纬度方向的变化量
 * @param longitudeDelta    [in] : 经度方向的变化量
 * @return 根据指定参数生成的TCoordinateSpan
 */
NS_INLINE TCoordinateSpan TCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta) {
    TCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

/**
 * 构造TCoordinateRegion
 * @param centerCoordinate  [in] : 中心点经纬度坐标
 * @param span              [in] : 经纬度的范围
 * @return 根据指定参数生成的TCoordinateSpan
 */
NS_INLINE TCoordinateRegion TCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, TCoordinateSpan span) {
    TCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;
    return region;
}
