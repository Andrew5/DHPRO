//
//  TPoiSearch.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-23.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSearchResult.h"
#import "TGeometry.h"

/// 检索类型
typedef enum eTSearchtype {
    normalSearch = 1,       ///<普通搜索
    viewmapSearch = 2,      ///<视野内搜索
    aroundSearch = 3,       ///<周边搜索
    wordsSearch = 4,        ///<建议词搜索
    buswordsSearch = 5,     ///<公交规划起止点搜索提示词搜索
    busSearch = 6,          ///<公交规划起止点搜索
    poiOnlySearch = 7,      ///<纯POI搜索(不搜公交线)
} TSearchtype;

/// 检索参数
@interface TPoiSearchParam : NSObject {
@private
    void *_internal;
}
/// 检索类型
@property(nonatomic) TSearchtype searchtype;
/// 关键字搜索
@property(nonatomic, copy) NSString *strkeyword;
/// 检索边界(经纬度，必须填写)
@property(nonatomic) CGRect searchbound;
/// 检索中心点(如果是周边检索，必须填写)
@property(nonatomic) CLLocationCoordinate2D searchCenter;
/// 当前位置
@property(nonatomic) CLLocationCoordinate2D position;
/// 当前地图比例尺
@property(nonatomic) NSUInteger mapscal;
/// 行政区编码
@property(nonatomic) NSUInteger searchareacode;
/// 周边检索半径
@property(nonatomic) NSUInteger searchradius;
/// 从第几条开始
@property(nonatomic) NSUInteger searchStart;
/// 检索多少条
@property(nonatomic) NSUInteger searchCounter;

@end

/// POI检索代理类
@protocol TPoiSearchDelegate;

/// POI检索类
@interface TPoiSearch : NSObject {
@private
    void *_internal;
}
/// 检索参数
@property(nonatomic, retain) TPoiSearchParam *param;
/// 回调托管
@property(nonatomic, assign) id <TPoiSearchDelegate> delegate;

/**
 * 开始检索
 * @return 操作是否成功
 */
- (BOOL)StartSearch;

/**
 * 结束检索
 * @return 操作是否成功
 */
- (BOOL)StopSearch;

/// 得到结果类型
@property(nonatomic, readonly) TSearchResultType resultType;
/// 得到POI检索结果
@property(nonatomic, readonly) NSArray *arrPoi;
/// POI结果的经纬度区域
@property(nonatomic, readonly) TCoordinateRegion poiRegion;
/// 总共的数量
@property(nonatomic, readonly) NSUInteger allCounter;

/// 统计结果
@property(nonatomic, readonly) TSearchStatics *Statics;
/// 公交线路结果 @see TBusLineRecord
@property(nonatomic, readonly) NSArray *arrBusLines;
/// 区域信息
@property(nonatomic, readonly) TSearchArea *area;
/// 提示信息
@property(nonatomic, readonly) NSArray *arrTips;
/// 建议词信息
@property(nonatomic, readonly) NSArray *arrSugest;
@end

/// 检索回调
@protocol TPoiSearchDelegate <NSObject>
@required
/**
 * 开始检索
 * @param search [in] : 检索类
 */
- (void)beginSearch:(TPoiSearch *)search;

/**
 * 检索到POI
 * @param search [in] : 检索类
 * @param PoiResult [in] : 检索POI的结果
 * @param allcounter [in] : 总共有多少个POI
 * @param arrTips [in] : 提示信息
 */
- (void)Search:(TPoiSearch *)search POIresult:(NSArray *)PoiResult allcounter:(NSUInteger)allcounter tips:(NSArray *)arrTips;

/**
 * 检索到统计结果
 * @param search [in] : 检索类
 * @param statics [in] : 统计信息
 * @param arrTips [in] : 提示信息
 */
- (void)Search:(TPoiSearch *)search statics:(TSearchStatics *)statics tips:(NSArray *)arrTips;

/**
 * 检索到公交线路
 * @param search [in] : 检索类
 * @param arrBuslines [in] : 检索的公交线路信息 @see TBusLineRecord
 * @param allcounter [in] : 总共有多少个公交线路
 * @param arrTips [in] : 提示信息
 */
- (void)Search:(TPoiSearch *)search buslines:(NSArray *)arrBuslines allcounter:(NSUInteger)allcounter tips:(NSArray *)arrTips;

/**
 * 检索到区域结果
 * @param search [in] : 检索类
 * @param area  [in] : 行政区信息
 * @param arrTips [in] : 提示信息
 */
- (void)Search:(TPoiSearch *)search areas:(TSearchArea *)area tips:(NSArray *)arrTips;

/**
 * 检索到建议词
 * @param search [in] : 检索类
 * @param arrsugest [in] : 建议词
 */
- (void)Search:(TPoiSearch *)search sugest:(NSArray *)arrsugest;

/**
 * 检索失败
 * @param search [in] : 检索类
 * @param error [in] : 错误信息
 */
- (void)Search:(TPoiSearch *)search error:(NSError *)error;

@end
