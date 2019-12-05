//
//  TOffLineManger.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-12.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMapView.h"
#import "TCityInfor.h"
#import "TDownLoadingCity.h"

@protocol OfflineDownManDelegate;
@protocol TOffLineMangerDelegate;
@class TOffLineMangerInternal;
@class TOffLineMapSearch;

/// 离线地图下载管理,这个常驻内存
@interface TOffLineManger : NSObject {
    TOffLineMangerInternal *internal;
}
/// 离线地图的路径
@property(nonatomic, readonly) NSString *strOffLinePath;
/// 回调托管
@property(nonatomic, assign) id <TOffLineMangerDelegate> delegate;

/**
 * 获得全局的地图下载管理类
 * 地图下载管理类只能通过这个函数获得，不能用户自己初始化
 */
+ (id)sharesInstance;

/**
 * 更新离线地图列表
 * @return 操作是否成功
 */
- (BOOL)UpDateMapList;

/// 得到地图列表管理类,生成效率较低,建议在使用期间保存
@property(nonatomic, readonly) TOffLineMapSearch *MapListManger;

/// 得到正在下载的离线地图信息(TDownLoadingCity)
@property(nonatomic, readonly) NSArray *arrDownLoadingMapList;

/**
 * 添加一个下载地图
 * @param mapinfor [in] : 要下载的城市
 * @return 操作是否成功
 */
- (BOOL)AddOneDownLoad:(TDownLoadingCity *)mapinfor;

/**
 * 删除一个下载的地图
 * @param mapinfor [in] : 要删除的地图信息
 * @return 操作是否成功
 */
- (BOOL)DeleteOneDownLoad:(TDownLoadingCity *)mapinfor;

/**
 * 开始下载某个地图
 * @param mapinfor [in] : 开始下载那个地图
 * @return 操作是否成功
 */
- (BOOL)StartDownLoadOneMap:(TDownLoadingCity *)mapinfor;

/**
 * 停止下载地图
 * @return 操作是否成功
 */
- (BOOL)StopDownMap;

/**
 * 开始下载地图
 * @return 操作是否成功
 */
- (BOOL)startDownLoadMap;

/// 得到已经下载的离线地图信息
@property(nonatomic, readonly) NSArray *arrDownedMapList;

/**
 * 删除一个已经下载的地图
 * @param offlinemap [in] : 要删除的地图
 * @return 操作是否成功
 */
- (BOOL)DeleteOneDownedMap:(TDownedMap *)offlinemap;

/**
 * 重新加载离线地图列表
 * @return 返回有多少个离线地图
 */
- (int)ReLoadDownedList;

@end

/// 离线地图管理回调托管
@protocol TOffLineMangerDelegate <NSObject>
@optional
/**
 * 下载完成
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 下载完成的地图信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadOver:(TDownLoadingCity *)mapinfor;

/**
 * 开始一个新的下载
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 开始下载的地图信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadstart:(TDownLoadingCity *)mapinfor;

/**
 * 开始一个新的下载，失败
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 开始下载出错的地图信息
 * @param error [in] : 出错信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadstart:(TDownLoadingCity *)mapinfor error:(NSError *)error;

/**
 * 停止下载
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 停止下载的地图信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadStop:(TDownLoadingCity *)mapinfor;

/**
 * 收到下载数据
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 下载中的地图信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownLoadData:(TDownLoadingCity *)mapinfor;

/**
 * 下载数据出错
 * @param offlinemanger [in] : 下载地图管理类
 * @param mapinfor [in] : 下载中的地图信息
 * @param error [in] : 出错信息
 */
- (void)TOffLineManger:(TOffLineManger *)offlinemanger DownInfor:(TDownLoadingCity *)mapinfor error:(NSError *)error;

/**
 * 更新列表完成
 * @param offlinemanger [in] : 下载地图管理类
 */
- (void)UpdateListOver:(TOffLineManger *)offlinemanger;

/**
 * 更新列表失败
 * @param offlinemanger [in] : 下载地图管理类
 * @param error [in] : 出错信息
 */
- (void)UpDateList:(TOffLineManger *)offlinemanger error:(NSError *)error;

@end

/// 离线地图搜索
@interface TOffLineMapSearch : NSObject {
    /// 省市信息(TProvinceInfor数组)
    NSMutableArray *m_arrprovince;
    void *internal;
}
/// 所有的省市信息
@property(nonatomic, retain, readonly) NSMutableArray *m_arrprovince;

/**
 * 在全国内搜索城市
 * @param strName [in] : 搜索的关键字
 * @return 搜索的结果
 */
- (NSArray *)SearchCity:(NSString *)strName;
@end
