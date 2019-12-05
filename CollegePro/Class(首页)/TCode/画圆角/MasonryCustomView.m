//
//  MasonryCustomView.m
//  RandomCornerDemo
//
//  Created by zzg on 2018/5/9.
//  Copyright © 2018年 Hikvision. All rights reserved.
//

#import "MasonryCustomView.h"

#import "UIView+RandomCorner.h"

@implementation MasonryCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //此时frame、bounds都是(origin = (x = 0, y = 0), size = (width = 0, height = 0))
    }
    
    return self;
}

//- (void)drawRect:(CGRect)rect {
//    //放在这里OK
//    [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    //放在这里OK
//    [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
//}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    //放在这里OK
    [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
}

@end
