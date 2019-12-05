//
//  TUserLocation.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-24.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CLLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "TAnnotation.h"

@class TUserLocationInternal;

/// 用户位置
@interface TUserLocation : NSObject <TAnnotation> {
@private
    TUserLocationInternal *interal;
}
/// 用户位置是否在更新中
@property(readonly, nonatomic, getter=isUpdating) BOOL updating;

/// 用户当前位置，如果没有得到过，那么返回nil
@property(readonly, retain, nonatomic) CLLocation *location;

/// 得到用户的方向信息，如果没有得到过，返回nil
@property(readonly, nonatomic, retain) CLHeading *heading;

/// 提示信息标题
@property(nonatomic, copy) NSString *title;

/// 提示信息子标题
@property(nonatomic, copy) NSString *subtitle;

@end
