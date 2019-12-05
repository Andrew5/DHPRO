//
//  TPolygonView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-19.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import "TOverlayPathView.h"
#import "TPolygon.h"

/// 多边形视图
@interface TPolygonView : TOverlayPathView

/**
 * 用多边形初始化
 * @param polygon [in] : 多边形
 * @param mapView [in] : 地图视图
 */
- (id)initWithPolygon:(TPolygon *)polygon mapView:(TMapView *)mapView;

/// 多边形信息
@property(nonatomic, readonly) TPolygon *polygon;
@end
