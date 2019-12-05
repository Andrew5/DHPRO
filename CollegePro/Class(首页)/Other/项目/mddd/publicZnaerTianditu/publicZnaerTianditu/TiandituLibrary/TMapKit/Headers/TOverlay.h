//
//  TOverlay.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-18.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAnnotation.h"

/// 覆盖物
@protocol TOverlay <TAnnotation>
@required
/// 覆盖物的中心点
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
/// 覆盖物的边界
@property(nonatomic, readonly) CGRect boundingMapRect;
@optional
/**
 * 覆盖物是否与边界相交
 * @param mapRect [in] : 当前要显示的视图范围（经纬度）
 * @return 覆盖物是否跟mapRect相交
 */
- (BOOL)intersectsMapRect:(CGRect)mapRect;
@end
