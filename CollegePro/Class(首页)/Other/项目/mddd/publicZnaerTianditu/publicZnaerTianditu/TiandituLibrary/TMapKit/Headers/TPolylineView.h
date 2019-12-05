//
//  TPolylineView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-19.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import "TOverlayView.h"
#import "TOverlayPathView.h"
#import "TPolyline.h"

/// 折线信息视图
@interface TPolylineView : TOverlayPathView
/// 曲线信息
@property(nonatomic, readonly) TPolyline *polyline;

/**
 * 初始化
 * @param polyline [in] : 折线覆盖物
 * @param mapView  [in] : 地图视图
 * @return 视图结果
 */
- (id)initWithPolyline:(TPolyline *)polyline mapView:(TMapView *)mapView;
@end
