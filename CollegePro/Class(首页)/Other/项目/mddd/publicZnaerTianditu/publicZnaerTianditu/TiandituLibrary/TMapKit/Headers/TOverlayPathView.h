//
//  TOverlayPathView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-10-19.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import "TOverlayView.h"

/// 覆盖物路线视图
@interface TOverlayPathView : TOverlayView
/// 填充颜色，默认为nil
@property(retain) UIColor *fillColor;
/// 边线颜色，默认为nil
@property(retain) UIColor *strokeColor;

/// 线宽默认是1
@property CGFloat lineWidth;
/// 默认是  kCGLineJoinRound
@property CGLineJoin lineJoin;
/// 默认是 kCGLineCapRound
@property CGLineCap lineCap;
/// 默认是 10
@property CGFloat miterLimit;
/// 默认是 0
@property CGFloat lineDashPhase;
@end
