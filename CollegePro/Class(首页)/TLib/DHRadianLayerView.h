//
//  DHRadianLayerView.h
//  B
//
//  Created by jabraknight on 2019/9/26.
//  Copyright © 2019 jabraknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, DXRadianDirection) {
    DXRadianDirectionBottom     = 0,
    DXRadianDirectionTop        = 1,
    DXRadianDirectionLeft       = 2,
    DXRadianDirectionRight      = 3,
};
@interface DHRadianLayerView : UIView
// 圆弧方向, 默认在下方
@property (nonatomic) DXRadianDirection direction;
// 圆弧高/宽, 可为负值。 正值凸, 负值凹
@property (nonatomic) CGFloat radian;

@end

NS_ASSUME_NONNULL_END
