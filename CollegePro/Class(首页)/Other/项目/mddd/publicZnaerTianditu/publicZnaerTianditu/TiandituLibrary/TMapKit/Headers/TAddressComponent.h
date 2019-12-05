//
//  TAddressComponent.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-24.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol TAddressComponentdelegate;

/// 逆地理编码类
@interface TAddressComponent : NSObject {
@private
    void *_internal;
    void *_info;
}

/// 回调托管
@property(nonatomic, assign) id <TAddressComponentdelegate> delegate;

/**
 * 开始查询某个点的地址信息
 * @param coordinate [in] : 需要查询的点
 * @return 操作是否成功
 */
- (BOOL)StartSearch:(CLLocationCoordinate2D)coordinate;

/**
 * 停止查询
 * @return 操作是否成功
 */
- (void)StopSearch;

/// 是否有检索结果
@property(nonatomic, readonly) BOOL isHaseResult;

/// POI名称
@property(nonatomic, readonly) NSString *strPoiName;
/// POI距离
@property(nonatomic, readonly) NSUInteger lPOiDistance;
/// POI所在方向描述
@property(nonatomic, readonly) NSString *strPoiDirection;

/// 道路的名称
@property(nonatomic, readonly) NSString *strRoadName;
/// 道路距离
@property(nonatomic, readonly) NSUInteger lRoadDistance;

/// 地址信息
@property(nonatomic, readonly) NSString *strAddressName;
/// 地址距离
@property(nonatomic, readonly) NSUInteger lAddressDistance;
/// 地址所在方向描述
@property(nonatomic, readonly) NSString *strAddressDirection;

/// 查询点的综合描述
@property(nonatomic, readonly) NSString *strAdministrative;

/// 查询到最近的点的位置
@property(nonatomic, readonly) CLLocationCoordinate2D PoiPosition;
/// 查询的位置
@property(nonatomic, readonly) CLLocationCoordinate2D SearchPosition;

@end

/// 逆地理编码代理类
@protocol TAddressComponentdelegate <NSObject>
@required
/**
 * 查询结束
 * @param address : 查询的结果
 */
- (void)SearchOver:(TAddressComponent *)address;

/**
 * 查询出错
 * @param address : 查询的结果
 * @param error : 错误原因
 */
- (void)AddressComponent:(TAddressComponent *)address error:(NSError *)error;
@end
