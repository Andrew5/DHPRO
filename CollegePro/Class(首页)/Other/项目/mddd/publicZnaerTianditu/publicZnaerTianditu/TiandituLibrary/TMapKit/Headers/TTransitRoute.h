//
//  TTransitRoute.h
//  TDT_MapKit
//
//  Created by zhaoxibo on 13-5-16.
//  Copyright 2013 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TGeometry.h"

/// 公交规划类型
typedef enum eTTransitRouteType {
    TRANSIT_ROUTE_TYPE_QUICKLY = 1,           ///<较快捷
    TRANSIT_ROUTE_TYPE_LESSTRANSFER = 2,      ///<少换乘
    TRANSIT_ROUTE_TYPE_LESSWALK = 4,          ///<少步行
    TRANSIT_ROUTE_TYPE_NOSUBWAY = 8,          ///<不坐地铁
    TRANSIT_ROUTE_TYPE_MAX = 255,             ///<
} TTransitRouteType;

/// 公交规划路段类型
typedef enum eTTransitSegmentType {
    TRANSIT_SEGMENT_TYPE_WALK = 1,            ///<步行
    TRANSIT_SEGMENT_TYPE_BUS,                 ///<公交
    TRANSIT_SEGMENT_TYPE_SUBWAY,              ///<地铁
    TRANSIT_SEGMENT_TYPE_SUBWAYTRANSFER,      ///<地铁站内换乘
    TRANSIT_SEGMENT_TYPE_MAX = 255,           ///<
} TTransitSegmentType;

@class TTransitRouteResult;

/// 公交规划委托
@protocol TTransitRouteDelegate <NSObject>

@required

/**
 * 公交规划结果回调函数
 * @param pTransitResult    [in] : 公交规划结果类
 * @param iErrorCode        [in] : 规划结果错误码
 */
- (void)transitRouteResult:(TTransitRouteResult *)pTransitResult
                 errorCode:(int)iErrorCode;

@end

/// 公交规划类
@interface TTransitRoute : NSObject {
@private
    void *_internal;
    /// 自驾规划委托
    id <TTransitRouteDelegate> _delegate;
}
/// 自驾规划委托
@property(nonatomic, assign) id <TTransitRouteDelegate> delegate;

/**
 * 开始公交规划
 * @param startPoi [in] : 起点经纬度坐标
 * @param endPoi  [in] : 终点经纬度坐标
 * @param eTransitType [in] : 规划类型
 * @return 操作是否成功
 */
- (BOOL)startRoute:(CLLocationCoordinate2D)startPoi
               end:(CLLocationCoordinate2D)endPoi
              type:(TTransitRouteType)eTransitType;

/**
 * 结束公交规划
 * @return 操作是否成功
 */
- (BOOL)endRoute;

@end

/// 公交规划结果类
@interface TTransitRouteResult : NSObject {
@private
    void *_internal;
}

/// 是否包含地铁
@property(nonatomic, readonly) BOOL hasSubway;
/// 多种规划类型结果
@property(nonatomic, readonly) NSArray *result;

@end

/// 公交规划单个类型结果类
@interface TTransitRouteSingleTypeResult : NSObject {
@private
    void *_internal;
}

/// 公交规划类型
@property(nonatomic, readonly) TTransitRouteType type;
/// 所有方案
@property(nonatomic, readonly) NSArray *line;

@end

/// 公交规划方案类
@interface TTransitRouteLine : NSObject {
@private
    void *_internal;
}

/// 方案名称
@property(nonatomic, readonly) NSString *name;
/// 方案总距离（单位：米）
@property(nonatomic, readonly) float distance;
/// 方案总时间（单位：分钟）
@property(nonatomic, readonly) long costTime;
/// 方案总站数
@property(nonatomic, readonly) int stationCount;
/// 方案中所有路段
@property(nonatomic, readonly) NSArray *segment;
/// 线路经纬度区域
@property(nonatomic, readonly) TCoordinateRegion region;

@end

@class TTransitRouteStation;

/// 公交规划路段类
@interface TTransitRouteSegment : NSObject {
@private
    void *_internal;
}
/// 路段起点信息
@property(nonatomic, readonly) TTransitRouteStation *start;
/// 路段终点信息
@property(nonatomic, readonly) TTransitRouteStation *end;
/// 路段类型
@property(nonatomic, readonly) TTransitSegmentType type;
/// 路段所有方案
@property(nonatomic, readonly) NSArray *segmentLine;

@end

/// 公交规划路段方案类
@interface TTransitRouteSegmentLine : NSObject {
@private
    void *_internal;
@public
    /// 路段形状点经纬度坐标
    CLLocationCoordinate2D *_shapePoints;
}

/// 路段距离（单位：米）
@property(nonatomic, readonly) int distance;
/// 路段时间（单位：分钟）
@property(nonatomic, readonly) int costTime;
/// 路段方向描述
@property(nonatomic, readonly) NSString *direction;
/// 路段名称
@property(nonatomic, readonly) NSString *name;
/// 路段ID
@property(nonatomic, readonly) NSString *segmentId;
/// 路段形状点经纬度坐标
@property(nonatomic, readonly) CLLocationCoordinate2D *shapePoints;
/// 路段形状点个数
@property(nonatomic, readonly) int pointCount;
/// 路段经过站数
@property(nonatomic, readonly) int stationCount;
/// 路段换乘时间（单位：分钟）
@property(nonatomic, readonly) int transferTime;

@end


/// 公交规划站点信息类
@interface TTransitRouteStation : NSObject {
@private
    void *_internal;
}

/// 站点名称
@property(nonatomic, readonly) NSString *name;
/// 站点ID
@property(nonatomic, readonly) NSString *stationId;
/// 站点坐标
@property(nonatomic, readonly) CLLocationCoordinate2D point;

@end
