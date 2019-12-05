//
//  TPolygon.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-19.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import "TMultiPoint.h"

/// 面覆盖物
@interface TPolygon : TMultiPoint {
    /// 存储NSIndex 描述每一个多边形,nill 代表就是一个多边形
    NSArray *_interiorPolygons;
}
/**
 * 生成面的覆盖物
 * @param coords [in] : 组成多边形的点
 * @param count  [in] : 点的个数
 * @return 面覆盖物
 */
+ (TPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

/**
 * 生成面的覆盖物
 * @param coords [in] : 组成多边形的点
 * @param count  [in] : 点的个数
 * @param interiorPolygons  [in] : 每个小面的点的索引
 * @return 面覆盖物
 */
+ (TPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

@end
