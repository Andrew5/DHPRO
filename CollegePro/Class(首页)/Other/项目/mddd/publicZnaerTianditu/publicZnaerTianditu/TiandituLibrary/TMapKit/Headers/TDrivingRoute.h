//
//  TDrivingRoute.h
//  TDT_MapKit
//
//  Created by zhaoxibo on 13-5-13.
//  Copyright 2013 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TGeometry.h"

/// 自驾规划类型
typedef enum eTDrivingRouteType {
    DRIVING_TYPE_FASTEST = 0,       ///<最快路线
    DRIVING_TYPE_SHORTEST,          ///<最短路线
    DRIVING_TYPE_NOHIGHWAY,         ///<少走高速
    DRIVING_TYPE_MAX = 255,
} TDrivingRouteType;

@class TDrivingRouteResult;

/// 自驾规划委托
@protocol TDrivingRouteDelegate <NSObject>

@required
/**
 * 自驾规划结果回调函数
 * @param pDrivingRouteResult   [in] : 自驾规划结果类指针
 * @param iErrorCode            [in] : 规划结果错误码
 */
- (void)drivingRouteResult:(TDrivingRouteResult *)pDrivingRouteResult
                 errorCode:(int)iErrorCode;

@end

/// 自驾规划类
@interface TDrivingRoute : NSObject {
@private
    void *_internal;
    /// 自驾规划委托
    id <TDrivingRouteDelegate> _delegate;
}

/// 自驾规划委托
@property(nonatomic, assign) id <TDrivingRouteDelegate> delegate;

/**
 * 开始自驾规划
 * @param startPoi [in] : 起点经纬度坐标
 * @param endPoi  [in] : 终点经纬度坐标
 * @param midPoi  [in] : 途经点经纬度坐标
 * @param iMidCount [in] : 途经点数量（最多四个）
 * @param eDrivingType [in] : 规划类型
 * @return 操作是否成功
 */
- (BOOL)startRoute:(CLLocationCoordinate2D)startPoi
               end:(CLLocationCoordinate2D)endPoi
               mid:(CLLocationCoordinate2D *)midPoi
          midCount:(int)iMidCount
              type:(TDrivingRouteType)eDrivingType;

/**
 * 结束自驾规划
 * @return 操作是否成功
 */
- (BOOL)endRoute;

@end

/// 自驾规划结果类
@interface TDrivingRouteResult : NSObject {
@private
    void *_internal;
}

/// 路线总距离（单位：公里）
@property(nonatomic, readonly) float distance;
/// 路线总时间（单位：秒）
@property(nonatomic, readonly) long costTime;
/// 路线外接矩形中心点
@property(nonatomic, readonly) CLLocationCoordinate2D centerPoint;
/// 规划结果类型
@property(nonatomic, readonly) TDrivingRouteType type;
/// 路线数组（TDrivingRouteRoad）
@property(nonatomic, readonly) NSArray *road;
/// 线路经纬度区域
@property(nonatomic, readonly) TCoordinateRegion region;

@end

/// 自驾规划路线类
@interface TDrivingRouteRoad : NSObject {
@private
    void *_internalRoad;
    void *_internalSimple;
@public
    /// 路线形状点经纬度坐标
    CLLocationCoordinate2D *_shapePoints;
}
/// 路线形状点经纬度坐标
@property(nonatomic, readonly) CLLocationCoordinate2D *shapePoints;
/// 路线形状点个数
@property(nonatomic, readonly) int pointCount;
/// 所有路段
@property(nonatomic, readonly) NSArray *roadSegment;
/// 所有路段概要信息
@property(nonatomic, readonly) NSArray *simpleSegment;

@end

/// 自驾规划路段类
@interface TDrivingRouteRoadSegment : NSObject {
@private
    void *_internalRoadSegment;
}

/// 路段描述信息
@property(nonatomic, readonly) NSString *description;
/// 当前道路名
@property(nonatomic, readonly) NSString *curStreetName;
/// 上一条道路名
@property(nonatomic, readonly) NSString *lastStreetName;
/// 下一条道路名
@property(nonatomic, readonly) NSString *nextStreetName;
/// 转向点坐标
@property(nonatomic, readonly) CLLocationCoordinate2D turnPoint;
/// 路段距离（单位：米）
@property(nonatomic, readonly) int distance;
/// 收费信息（0免费路段；1收费路段；2部分收费路段。）
@property(nonatomic, readonly) int tollInfo;

@end

/// 自驾规划路段概要信息类
@interface TDrivingRouteSimpleSegment : NSObject {
@private
    void *_internalSimpleSegment;
    void *_internalRoad;
}

/// 路段概要信息所包含的所有路段
@property(nonatomic, readonly) NSArray *roadSegment;
/// 路段描述信息
@property(nonatomic, readonly) NSString *description;
/// 当前道路名
@property(nonatomic, readonly) NSString *curStreetName;
/// 上一条道路名
@property(nonatomic, readonly) NSString *lastStreetName;
/// 下一条道路名
@property(nonatomic, readonly) NSString *nextStreetName;
/// 转向点坐标
@property(nonatomic, readonly) CLLocationCoordinate2D turnPoint;
/// 路段距离（单位：米）
@property(nonatomic, readonly) int distance;
/// 收费信息（0免费路段；1收费路段；2部分收费路段。）
@property(nonatomic, readonly) int tollInfo;

@end
