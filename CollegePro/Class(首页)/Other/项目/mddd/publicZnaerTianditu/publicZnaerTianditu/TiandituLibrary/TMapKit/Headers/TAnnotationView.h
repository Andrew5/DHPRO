//
//  TAnnotationView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-21.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAnnotation.h"

typedef enum {
    TAnnotationViewDragStateNone = 0,      ///<没有任何拖动操作
    TAnnotationViewDragStateStarting,      ///<视图即将被拖动
    TAnnotationViewDragStateDragging,      ///<视图正在拖动
    TAnnotationViewDragStateCanceling,     ///<取消视图拖动
    TAnnotationViewDragStateEnding         ///<视图拖动完毕，付给新的位置
} TAnnotationViewDragState;
@class TAnnotationViewInternal;

/// 动态标注视图
@interface TAnnotationView : UIView {
@private
    TAnnotationViewInternal *internal;
}

/**
 * 初始化动态标注视图
 * @param annotation : 动态标注
 * @param reuseIdentifier : 视图的标识
 * @return 初始化后的对象
 */
- (id)initWithAnnotation:(id <TAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

/// 视图标识
@property(nonatomic, readonly) NSString *reuseIdentifier;

/**
 * 为重用做准备，如果此函数被重载，那么必须调用
 * super.prepareForReuse
 */
- (void)prepareForReuse;

/// 动态标注视图的动态标注
@property(nonatomic, retain) id <TAnnotation> annotation;

/// 标注的图片
@property(nonatomic, retain) UIImage *image;
/// 选中状态下图片
@property(nonatomic, retain) UIImage *selectImage;

/// 动态标注图片位置的偏移量，默认位置是在图片的中心
@property(nonatomic) CGPoint centerOffset;

/// 动态标注视图的提示视图，在视图上的位置，默认是在正上方
@property(nonatomic) CGPoint calloutOffset;

/// 是否可以点击，默认是可以点击
@property(nonatomic, getter=isEnabled) BOOL enabled;

/// 是否是高亮状态，默认是非高亮状态
@property(nonatomic, getter=isHighlighted) BOOL highlighted;

/// 是否选中状态，默认是非选中状态
@property(nonatomic, getter=isSelected) BOOL selected;

/**
 * 设置标注为选中状态
 * @param selected [in] : 是否为选中状态 yes: 为选中状态 no: 非选中状态
 * @param animated [in] : 是否以动画方式显示callout
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// 是否可以显示callout ，假如为true,当视图被选中时callout被调用显示。并且annotation 必须实现title
@property(nonatomic) BOOL canShowCallout;
/// calloutview 默认为nil，如果为nil 显示默认视图
@property(nonatomic, retain) UIView *CalloutView;

/// callout 左边快捷视图，默认为nil
@property(retain, nonatomic) UIView *leftCalloutAccessoryView;
/// callout 右边快捷视图，默认为nil
@property(retain, nonatomic) UIView *rightCalloutAccessoryView;

/// 是否可以拖动，默认是no.如果是true,那么Annotation必须实现setCoordinate
@property(nonatomic, getter=isDraggable) BOOL draggable;

///视图的拖拽状态
@property(nonatomic) TAnnotationViewDragState dragState;

/**
 * 设置拖拽的状态
 * @param newDragState [in] : 设置的拖拽状态
 * @param animated     [in] : 动画方式
 */
- (void)setDragState:(TAnnotationViewDragState)newDragState animated:(BOOL)animated;
@end
