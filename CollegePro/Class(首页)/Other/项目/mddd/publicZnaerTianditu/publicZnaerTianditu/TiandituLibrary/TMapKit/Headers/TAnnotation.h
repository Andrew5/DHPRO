//
//  TAnnotation.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-21.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 动态标注
@protocol TAnnotation <NSObject>
/// 动态标注的中心点，是经纬度信息
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

/// 动态标注的标题，用户callout
@property(nonatomic, readonly, copy) NSString *title;
/// 动态标注的子标题
@property(nonatomic, readonly, copy) NSString *subtitle;

/**
 * 设置新的位置，如果动态标注视图可以拖动，那么此函数必须实现
 * @param newCoordinate [in] : 新的中心点
 */
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
