//
//  TBusLineSearch.h
//  TDT_MapKit
//
//  Created by apple on 13-5-8.
//  Copyright 2013 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TGeometry.h"

/// 线路类型
typedef enum {
    T_BUSLINETYPE_BUS = 1,  ///<公交
    T_BUSLINETYPE_SUBWAY,   ///<地铁
    T_BUSLINETYPE_MAGLEV,   ///<磁悬浮
} TBusLineType;

/// 公交线路的站点信息
@interface TBusLineStation : NSObject {
@private
    void *_internal;
}

/// 站点id
@property(nonatomic, readonly) NSString *strId;
/// 站点名称
@property(nonatomic, readonly) NSString *strName;
/// 位置
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

/// 公交线路的详细信息
@interface TBusLineInfo : NSObject {
@private
    void *_internal;
}

/// 线路id
@property(nonatomic, readonly) NSString *strId;
/// 线路类型
@property(nonatomic, readonly) TBusLineType eLineType;
/// 线路名称
@property(nonatomic, readonly) NSString *strName;
/// 线路全程里程单位米
@property(nonatomic, readonly) NSUInteger iLength;
/// 所属公交公司
@property(nonatomic, readonly) NSString *strCompany;
/// 始发车时间，格式为：hh:mm 24小时制
@property(nonatomic, readonly) NSString *strStartTime;
/// 末班车时间，格式为：hh:mm 24小时制
@property(nonatomic, readonly) NSString *strEndTime;
/// 线路经纬度点
@property(nonatomic, readonly) CLLocationCoordinate2D *arrPoint;
/// 纬度点个数
@property(nonatomic, readonly) NSInteger iPointCount;
/// 经过的站点 @see TBusLineStation
@property(nonatomic, readonly) NSArray *arrStation;
/// 线路经纬度区域
@property(nonatomic, readonly) TCoordinateRegion region;

@end

@protocol TBusLineSearchDelegate;

/// 公交线路检索参数
@interface TBusLineSearch : NSObject {
@private
    void *_internal;
}

/// 回调托管
@property(nonatomic, assign) id <TBusLineSearchDelegate> delegate;
/// 线路id
@property(nonatomic, readonly) NSString *strId;
/// 公交线路的详细信息
@property(nonatomic, readonly) TBusLineInfo *busLine;

/**
 * 开始检索
 * @param strId : 线路id
 * @return 操作是否成功
 */
- (BOOL)StartSearch:(NSString *)strId;

/**
 * 结束检索
 * @return 操作是否成功
 */
- (BOOL)StopSearch;

@end

/// 公交线路检索回调
@protocol TBusLineSearchDelegate <NSObject>
@required
/**
 * 开始检索
 * @param search : 检索类
 */
- (void)beginSearch:(TBusLineSearch *)search;

/**
 * 检索到公交线路
 * @param search : 检索类
 * @param busLine : 公交线路的详细信息
 */
- (void)Search:(TBusLineSearch *)search busLine:(TBusLineInfo *)busLine;

/**
 * 检索失败
 * @param search : 检索类
 * @param error : 错误信息
 */
- (void)Search:(TBusLineSearch *)search error:(NSError *)error;

@end