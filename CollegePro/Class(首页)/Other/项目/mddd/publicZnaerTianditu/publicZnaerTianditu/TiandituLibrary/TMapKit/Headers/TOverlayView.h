//
//  TOverlayView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-18.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOverlay.h"

@class TMapView;

/// 覆盖物视图
@interface TOverlayView : UIView {
    id <TOverlay> _overlay;
    TMapView *_mapView;
}

/**
 * 初始化
 * @param overlay [in] : 覆盖物
 * @param mapView [in] : 覆盖物所属的地图视图
 */
- (id)initWithOverlay:(id <TOverlay>)overlay mapView:(TMapView *)mapView;

/// 覆盖物
@property(nonatomic, readonly) id <TOverlay> overlay;

/**
 * 地理坐标到屏幕坐标转换
 * @param pt [in] : 地理坐标
 * @return 屏幕坐标
 */
- (CGPoint)PointFromMap:(CLLocationCoordinate2D)pt;

/**
 * 是否可以在当前范围内显示，
 * 此函数用于地图视图显示覆盖物是调用
 * @param mapRect   [in] : 地理坐标范围
 * @param zoomScale [in] : 当前地图范围
 * @return 返回是否可以显示
 */
- (BOOL)canDrawMapRect:(CGRect)mapRect
             zoomScale:(int)zoomScale;

/**
 * 显示覆盖物
 * 此函数用于地图视图显示覆盖物是调用
 * @param mapRect   [in] : 地理坐标范围
 * @param zoomScale [in] : 当前地图范围
 * @param context   [in] : 绘图设备
 */
- (void)drawMapRect:(CGRect)mapRect
          zoomScale:(int)zoomScale
          inContext:(CGContextRef)context;

@end
