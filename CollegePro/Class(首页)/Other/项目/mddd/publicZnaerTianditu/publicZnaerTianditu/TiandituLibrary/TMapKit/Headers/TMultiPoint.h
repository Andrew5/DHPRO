//
//  TMultiPoint.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-18.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TOverlay.h"

/// 点的集合类
@interface TMultiPoint : NSObject <TOverlay> {
@private
    CLLocationCoordinate2D *arrcoords;
    NSUInteger coordscounter;
    CGRect rcbound;
}
/// 得到所有的经纬度坐标
@property(nonatomic, readonly) CLLocationCoordinate2D *coords;
/// 有多少个点
@property(nonatomic, readonly) NSUInteger icounter;
@end
