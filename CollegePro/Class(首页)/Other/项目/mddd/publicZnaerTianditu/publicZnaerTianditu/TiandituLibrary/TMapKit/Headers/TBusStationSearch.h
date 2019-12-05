//
//  TBusStationSearch.h
//  TDT_MapKit
//
//  Created by apple on 13-5-7.
//  Copyright 2013 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 公交站点信息
@interface TBusStationInfo : NSObject {
@private
    void *_internal;
}

/// 站点id
@property(nonatomic, readonly) NSString *strId;
/// 站点名称
@property(nonatomic, readonly) NSString *strName;
/// 位置
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
/// 公交线路 @see TBusLine
@property(nonatomic, readonly) NSArray *arrBusLines;

@end

@protocol TBusStationSearchDelegate;

/// 公交站点检索
@interface TBusStationSearch : NSObject {
@private
    void *_internal;
}

/// 回调托管
@property(nonatomic, assign) id <TBusStationSearchDelegate> delegate;
/// 站点id
@property(nonatomic, readonly) NSString *strId;
/// 公交站点的详细信息
@property(nonatomic, readonly) TBusStationInfo *busStation;

/**
 * 开始检索
 * @param strId : 站点id
 * @return 操作是否成功
 */
- (BOOL)StartSearch:(NSString *)strId;

/**
 * 结束检索
 * @return 操作是否成功
 */
- (BOOL)StopSearch;

@end

/// 公交站点检索回调
@protocol TBusStationSearchDelegate <NSObject>
@required
/**
 * 开始检索
 * @param search : 检索类
 */
- (void)beginSearch:(TBusStationSearch *)search;

/**
 * 检索到公交线路
 * @param search : 检索类
 * @param busStation : 公交站点的详细信息
 */
- (void)Search:(TBusStationSearch *)search busStation:(TBusStationInfo *)busStation;

/**
 * 检索失败
 * @param search : 检索类
 * @param error : 错误信息
 */
- (void)Search:(TBusStationSearch *)search error:(NSError *)error;

@end