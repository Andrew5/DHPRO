//
//  TMapView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-14.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TMapLayerInfo.h"
#import "CoreLocation/CLLocation.h"
#import "TAnnotationView.h"
#import "TUserLocation.h"
#import "TOverlayView.h"
#import "TGeometry.h"

/// 跟踪模式
typedef enum {
    TUserTrackingModeNone = 0, ///<地图不随着用户的位置进行移动
    TUserTrackingModeFollow,   ///<地图随着用户的位置进行移动

} TUserTrackingMode;

@protocol TMapViewDelegate;
@class TMapViewInternal;

/// 地图显示类
@interface TMapView : UIView <CLLocationManagerDelegate> {
@private
    TMapViewInternal *m_internal;
}

/// 代理类
@property(nonatomic, assign) id <TMapViewDelegate> delegate;
/// 当前地图类型(图层的索引,如果不想用太多,0是影像,1是矢量)
@property(nonatomic) int CurentMapType;

/**
 * 得到当前地图的图层信息
 * @return 所有图层信息
 */
- (NSArray *)getAllMapLayer;

/// 当前地图的经纬度范围，设定该范围可能会被调整为适合地图窗口显示的范围
@property(nonatomic) TCoordinateRegion region;

/**
 * 设定当前地图的显示范围
 * @param region    [in] : 地图的范围
 * @param animated  [in] : 是否以动画方式移动地图
 */
- (void)setRegion:(TCoordinateRegion)region animated:(BOOL)animated;

/// 设置得到地图中心点
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;

/**
 * 设置中心点信息
 * @param coordinate    [in] : 地图新的中心点
 * @param animated      [in] : 是否以动画方式移动地图
 * @return 无
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/**
 * 根据当前地图的窗口大小调整传入的region，返回适合当前地图窗口显示的region，调整过程会保证中心点不改变
 * @param region    [in] : 待调整的经纬度范围
 * @return 调整后适合当前地图窗口显示的经纬度范围
 */
- (TCoordinateRegion)regionThatFits:(TCoordinateRegion)region;

/// 得到当前窗口的地图范围信息
@property(nonatomic, readonly) CGRect mapBound;
/// 当前地图的比例尺
@property(nonatomic) int mapScale;

/**
 * 当前地图的比例尺
 * @param iScale    [in] : 当前地图比例尺
 * @param animate   [in] : 是否以动画方式改变比例尺
 */
- (void)setMapScale:(int)iScale  animated:(BOOL)animate;

/// 能否缩小
@property(nonatomic, readonly) BOOL CanZoomOut;
/// 能否放大
@property(nonatomic, readonly) BOOL CanZoomIn;

/**
 * 放大一级比例尺
 * @return 放大是否成功
 */
- (BOOL)MapScaleAdd;

/**
 * 减小一级比例尺
 * @return 是否成功
 */
- (BOOL)MapScaleSub;

/**
 * 经纬度到屏幕坐标转换
 * @param coordinate [in] : 经纬度信息
 * @param view       [in] : 影射到那个View中
 * @return 在这个View中，变化后的屏幕坐标
 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

/**
 * 屏幕坐标到经纬度坐标的转换
 * @param point [in] : 屏幕坐标
 * @param view  [in] : 影射到那个View中
 * @return 当前View中屏幕点的经纬度
 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/**
 * 经纬度矩形区域到屏幕坐标矩形区域转换
 * @param region [in] : 经纬度矩形
 * @param view   [in] : 影射到那个View中
 * @return 在这个View中，变化后的屏幕坐标矩形区域
 */
- (CGRect)convertRegion:(TCoordinateRegion)region toRectToView:(UIView *)view;

/**
 * 屏幕坐标矩形区域到经纬度矩形区域的转换
 * @param rect  [in] : 屏幕坐标矩形区域
 * @param view  [in] : 影射到那个View中
 * @return 转换后的经纬度矩形区域
 */
- (TCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/**
 * 设置地图可视范围,用于地图标注显示用。地图的
 * 整个范围可能被菜单等遮盖
 * @param mapRect [in] :地图的可视范围
 * @param insets  [in] :边距
 * @param animate [in] :是否以动画方式变化
 */
- (void)setVisibleMapRect:(CGRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;

/**
 * 得到地图可视范围,用于地图标注显示用。地图的整个范围可能被菜单等遮盖
 * @return 地图的可视范围
 */
- (CGRect)mapRectThatFits;

/// 是否显示用户位置
@property(nonatomic) BOOL ShowPosition;
/// 当前跟踪模式,跟踪状态,还是地图漫游状态
@property(nonatomic) TUserTrackingMode UserTrackMode;

/**
 * 启动定位服务
 * @return 启动是否成功
 */
- (BOOL)StartGetPosition;

/**
 * 停止定位服务
 * @return 无
 */
- (void)StopGetPosition;

/// 当前用户位置信息
@property(nonatomic, readonly) TUserLocation *userLocation;

@end

/// 标注相关的地图视图
@interface TMapView (Annotation)

/// 所有动态标注
@property(nonatomic, readonly) NSArray *annotations;

/**
 * 添加动态标注
 * @param annotation [in] : 要添加的动态标注
 */
- (void)addAnnotation:(id <TAnnotation>)annotation;

/**
 * 添加一组动态标注
 * @param annotations [in] : 要添加的动态标注
 */
- (void)addAnnotations:(NSArray *)annotations;

/**
 * 删除动态标注
 * @param annotation [in] : 要删除的动态标注
 */
- (void)removeAnnotation:(id <TAnnotation>)annotation;

/**
 * 删除一组动态标注
 * @param annotations [in] : 要删除的动态标注
 */
- (void)removeAnnotations:(NSArray *)annotations;

/**
 * 设置某个动态标注被选中
 * @param annotation  [in] : 要选中的动态标注
 * @param animated    [in] : 是否以动画方式显示callout
 */
- (void)selectAnnotation:(id <TAnnotation>)annotation animated:(BOOL)animated;

/**
 * 取消某个动态标注的选中状态
 * @param annotation [in] : 要取消选中的动态标注
 * @param animated   [in] : 是否以动画方式隐藏callout
 */
- (void)deselectAnnotation:(id <TAnnotation>)annotation animated:(BOOL)animated;

/// 所有选中的动态标注
@property(nonatomic, copy) NSArray *selectedAnnotations;
/// 动态标注的可视的矩形范围
@property(nonatomic, readonly) CGRect annotationVisibleRect;

/**
 * 得到某一个动态标注的视图,如果该动态标注没有在可视范围内,那么返回视图为null
 * @param annotation [in] : 动态标注
 * @return 动态标注的视图
 */
- (TAnnotationView *)viewForAnnotation:(id <TAnnotation>)annotation;

/**
 * 从回收站中从新应用一个废弃的视图,
 * 在使用前要从新赋值Annotation
 * @param identifier [in] : 动态标注视图的标识
 * @return 动态标注的视图
 */
- (TAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

@end

/// 覆盖物相关的地图显示
@interface TMapView (overlay)
/**
 * 添加覆盖物
 * @param overlay [in] : 要添加的覆盖物
 */
- (void)addOverlay:(id <TOverlay>)overlay;

/**
 * 添加一组覆盖物
 * @param overlays [in] : 要添加的覆盖物
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 * 删除覆盖物
 * @param overlay [in] : 要删除的覆盖物
 */
- (void)removeOverlay:(id <TOverlay>)overlay;

/**
 * 删除一组覆盖物
 * @param overlays [in] : 要删除的覆盖物
 */
- (void)removeOverlays:(NSArray *)overlays;

/**
 * 插入一个覆盖物在某个位置
 * @param overlay   [in] : 要插入的覆盖物
 * @param index     [in] : 插入到index这个位置
 */
- (void)insertOverlay:(id <TOverlay>)overlay atIndex:(NSUInteger)index;

/**
 * 交换两个覆盖物的位置
 * @param index1 [in] : 要交换的位置1
 * @param index2 [in] : 要交换的位置2
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/**
 * 插入一个覆盖物,在某个覆盖物的上面
 * @param overlay [in] : 要插入的覆盖物
 * @param sibling [in] : 在这个覆盖物的上面插入
 */
- (void)insertOverlay:(id <TOverlay>)overlay aboveOverlay:(id <TOverlay>)sibling;

/**
 * 插入一个覆盖物,再某个覆盖物的下面
 * @param overlay [in] : 要插入的覆盖物
 * @param sibling [in] : 在这个覆盖物的下面插入
 */
- (void)insertOverlay:(id <TOverlay>)overlay belowOverlay:(id <TOverlay>)sibling;

/// 所有的覆盖物
@property(nonatomic, readonly) NSArray *overlays;

/**
 * 得到当前显示的覆盖物视图,如果没有创建就返回null
 * @param overlay [in] : 以该覆盖物生成视图
 * @return 生成的覆盖物视图
 */
- (TOverlayView *)viewForOverlay:(id <TOverlay>)overlay;
@end

/// MapView 回调托管类型
@protocol TMapViewDelegate <NSObject>
@optional

/**
 * 视图区域即将改变，在改变区域之前调用
 * @param mapView   [in] : 地图视图
 * @param animated  [in] : 是否以动画的方式改变
 */
- (void)mapView:(TMapView *)mapView regionWillChangeAnimated:(BOOL)animated;

/**
 * 视图区域已经改变，在改变区域之后调用
 * @param mapView   [in] : 地图视图
 * @param animated  [in] : 是否以动画的方式改变
 */
- (void)mapView:(TMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

/**
 * 用户实现创建一个动态标注视图
 * @param mapView    [in] : 图视图
 * @param annotation [in] : 动态标注
 * @return 生成的动态标注视图
 */
- (TAnnotationView *)mapView:(TMapView *)mapView viewForAnnotation:(id <TAnnotation>)annotation;

/**
 * 当地图可视范围内的动态标注视图全部生成后,调用
 * @param mapView [in] : 地图视图
 * @param views   [in] : 生成的所有标注视图
 * @return 无
 */
- (void)mapView:(TMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/**
 * 用户定义的动态标注的内容视图左右视图被点击,
 * 并且用户没有设置这些视图的消息响应,系统会默认调用这个函数
 * @param mapView   [in] : 地图视图
 * @param view      [in] : 点击的动态标注的视图
 * @param control   [in] : 点击的控件
 * @return 无
 */
- (void)mapView:(TMapView *)mapView annotationView:(TAnnotationView *)view calloutControlTapped:(UIControl *)control;

/**
 * 当一个动态标注被选中时,系统调用
 * @param mapView   [in] : 地图视图
 * @param view      [in] : 点击的动态标注的视图
 * @return 无
 */
- (void)mapView:(TMapView *)mapView didSelectAnnotationView:(TAnnotationView *)view;

/**
 * 当一个标注被非选中时,系统调用
 * @param mapView   [in] : 地图视图
 * @param view      [in] : 点击的动态标注的视图
 * @return 无
 */
- (void)mapView:(TMapView *)mapView didDeselectAnnotationView:(TAnnotationView *)view;

/**
 * 用户当前位置启动定位
 * @param mapView [in] : 地图视图
 */
- (void)mapViewWillStartLocatingUser:(TMapView *)mapView;

/**
 * 用户当前位置停止定位
 * @param mapView [in] : 地图视图
 */
- (void)mapViewDidStopLocatingUser:(TMapView *)mapView;

/**
 * 用户当前位置发生变化
 * @param mapView       [in] : 地图视图
 * @param userLocation  [in] : 用户的新位置
 */
- (void)mapView:(TMapView *)mapView didUpdateUserLocation:(TUserLocation *)userLocation;

/**
 * 定位出错
 * @param mapView   [in] : 地图视图
 * @param error     [in] : 错误原因
 */
- (void)mapView:(TMapView *)mapView didFailToLocateUserWithError:(NSError *)error;

/**
 * 一个标注视图的拖动状态发生变化
 * @param mapView   [in] : 地图视图
 * @param view      [in] : 变化的动态标注视图
 * @param newState  [in] : 新的状态
 * @param oldState  [in] : 老的状态
 */
- (void)mapView:(TMapView *)mapView annotationView:(TAnnotationView *)view didChangeDragState:(TAnnotationViewDragState)newState fromOldState:(TAnnotationViewDragState)oldState;

/**
 * 生成一个覆盖物的视图
 * @param mapView [in] : 地图视图
 * @param overlay [in] : 需要生成覆盖物视图的覆盖物
 * @return 生成的覆盖物视图
 */
- (TOverlayView *)mapView:(TMapView *)mapView viewForOverlay:(id <TOverlay>)overlay;

/**
 * 覆盖物视图全部被生产完毕
 * @param mapView       [in] : 地图视图
 * @param overlayViews  [in] : 生成的所有覆盖物视图
 */
- (void)mapView:(TMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews;

/**
 * 地图浏览模式发生变化
 * @param mapView   [in] : 地图视图
 * @param mode      [in] : 变化后的地图浏览模式
 * @param animated  [in] : 是否是动画变化
 */
- (void)mapView:(TMapView *)mapView didChangeUserTrackingMode:(TUserTrackingMode)mode animated:(BOOL)animated;

@end
