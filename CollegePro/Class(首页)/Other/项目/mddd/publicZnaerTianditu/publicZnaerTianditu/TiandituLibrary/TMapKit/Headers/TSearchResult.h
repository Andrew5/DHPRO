//
//  TSearchResult.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-23.
//  Copyright 2012 Tianditu Inc All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/// 检索结果类型
typedef enum emTSearchResultType {
    TSR_POISEARCH = 1,       ///<POI检索
    TSR_STATISTICS = 2,        ///<统计
    TSR_AREA = 3,              ///<行政区结果
    TSR_SUGGEST = 4,           ///<建议词搜索
    TSR_BUSLINE = 5,           ///<线路结果
    TSR_MAX = 255,           ///<
} TSearchResultType;

/// 提示类型
typedef enum eSearchTipsType {
    T_Prompt_Suggest = 1,    ///<是否在where搜what
    T_Prompt_NoResult,       ///<在where无搜索what的结果
    T_Prompt_Citys,          ///<多个可跳转的行政区提示
    T_Prompt_City,           ///<城市
    T_Prompt_PoiOnly = 100,  ///<是否在where搜what 纯POI搜索（不搜索公交线）
} SearchTipsType;

/// POI类型
typedef enum eTPOIRecordType {
    T_POITYPE_DEFAULT = 1,   ///<普通POI
    T_POITYPE_STATION = 102, ///<公交站
} TPOIRecordType;

/// 公交线路信息
@interface TBusLine : NSObject {
@private
    void *_internal;
}
/// 线路名称
@property(nonatomic, readonly) NSString *strName;
/// 线路id
@property(nonatomic, readonly) NSString *strId;

@end

/// 检索到POI的结果
@interface TPoiRecord : NSObject {
@private
    void *_internal;
}
/// POI名称
@property(nonatomic, readonly) NSString *strName;
/// POI地址
@property(nonatomic, readonly) NSString *strAddress;
/// 电话
@property(nonatomic, readonly) NSString *strtel;
/// 距离(周边检索)
@property(nonatomic, readonly) NSUInteger distance;
/// 位置
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
/// POI类型
@property(nonatomic, readonly) TPOIRecordType ePoiType;
/// 经过该公交站点的线路(当POI是公交站点时) @see TBusLine
@property(nonatomic, readonly) NSArray *arrBusLine;

@end

/// 检索到城市结果
@interface TSearchCity : NSObject {
@private
    void *_internal;
}
/// 城市名称
@property(nonatomic, readonly) NSString *strCityName;
/// 总共有多少搜索结果
@property(nonatomic, readonly) NSUInteger icounter;
/// 行政区编码
@property(nonatomic, readonly) NSUInteger citycode;

@end

/// 检索到省份结果
@interface TSearchProvince : NSObject {
@private
    void *_internal;
}
/// 城市名称
@property(nonatomic, readonly) NSString *strName;
/// 总共有多少搜索结果
@property(nonatomic, readonly) NSUInteger icounter;
/// 行政区编码
@property(nonatomic, readonly) NSUInteger citycode;
/// 城市信息
@property(nonatomic, readonly) NSArray *arrCity;

@end

/// 检索到国家结果
@interface TSearchCountry : NSObject {
@private
    void *_internal;
}
/// 国家名称
@property(nonatomic, readonly) NSString *strName;
/// 总共有多少搜索结果
@property(nonatomic, readonly) NSUInteger icounter;
/// 行政区编码
@property(nonatomic, readonly) NSUInteger code;
/// 省份信息
@property(nonatomic, readonly) NSArray *arrProvince;

@end

/// 统计结果
@interface TSearchStatics : NSObject {
@private
    void *_internal;
}
/// 总共有多少搜索结果
@property(nonatomic, readonly) NSUInteger icounter;
/// 总共有多少个城市
@property(nonatomic, readonly) NSUInteger citycounter;
/// 推荐城市 @see TSearchCity
@property(nonatomic, readonly) NSArray *arrPriority;
/// 推荐的检索信息
@property(nonatomic, readonly) NSString *strkeyword;
/// 省份信息 @see TSearchProvince
@property(nonatomic, readonly) NSArray *arrProvince;
/// 国家信息 @see TSearchCountry
@property(nonatomic, readonly) NSArray *arrCountry;

@end

/// 行政区单个区域
@interface TAreaRegion : NSObject {
@private
    CLLocationCoordinate2D *_arrPoint;
    NSInteger _icounter;
}
/// 区域的经纬度坐标
@property(nonatomic, readonly) CLLocationCoordinate2D *arrPoint;
/// 区域的坐标个数
@property(nonatomic, readonly) NSInteger icounter;
@end

/// 检索结果是区域
@interface TSearchArea : NSObject {
@private
    void *_internal;
}
/// 行政区名称
@property(nonatomic, readonly) NSString *strName;
/// 行政区边界
@property(nonatomic, readonly) CGRect bound;
/// 中心点
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
/// 地图合适比例尺
@property(nonatomic, readonly) NSUInteger maplevel;
/// 区域
@property(nonatomic, readonly) NSArray *arrRegion;

@end

/// 检索结果是提示信息的
@interface TSearchAdmins : NSObject {
@private
    void *_internal;
}
/// 行政区名称
@property(nonatomic, readonly) NSString *strName;
/// 行政区编码
@property(nonatomic, readonly) NSUInteger citycode;
@end

/// 检索提示
@interface TSearchTips : NSObject {
@private
    void *_internal;
}
/// 关键字
@property(nonatomic, readonly) NSString *strKeywords;
/// 提示类型
@property(nonatomic, readonly) SearchTipsType tipstype;
/// 提示区域
@property(nonatomic, readonly) NSArray *tipsAdmins;

@end

/// 检索建议词
@interface TSearchSuggest : NSObject {
@private
    void *_internal;
}
/// 建议词的POI
@property(nonatomic, readonly) NSString *strName;
/// POI地址
@property(nonatomic, readonly) NSString *strAddress;

@end

/// 检索到公交线路的结果
@interface TBusLineRecord : NSObject {
@private
    void *_internal;
}
/// 线路名称
@property(nonatomic, readonly) NSString *strName;
/// 线路id
@property(nonatomic, readonly) NSString *strId;
/// 站数
@property(nonatomic, readonly) NSUInteger iStationCount;

@end

