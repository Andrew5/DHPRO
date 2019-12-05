//
//  TPolyline.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-18.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMultiPoint.h"

/// 折线信息
@interface TPolyline : TMultiPoint {

}

/**
 * 生成折线信息
 * @param coords [in] : 经纬度点信息
 * @param count  [in] : 点的个数
 */
+ (TPolyline *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
@end
