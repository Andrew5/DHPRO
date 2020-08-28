//
//  CustomView.m
//  RandomCornerDemo
//
//  Created by zzg on 2018/5/9.
//  Copyright © 2018年 Hikvision. All rights reserved.
//

#import "CustomView.h"

#import "Masonry.h"

#import "UIView+RandomCorner.h"

@interface CustomView ()

@property (nonatomic, strong) UIView *autolayoutSubview;//相对布局的子视图

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        //如果初始化这个视图对象用的是initWithFrame方法，这里是OK的，但是如果是init，后面再设置的frame，这里也不行
//        [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        
        //使用frame创建的子视图，添加圆角
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        subView.backgroundColor = [UIColor blackColor];
        [self addSubview:subView];
        //添加圆角-OK
        [subView setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        
        //自定义视图中，使用自动布局的子视图
        self.autolayoutSubview = [[UIView alloc] init];
        self.autolayoutSubview.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.autolayoutSubview];
        [self.autolayoutSubview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.trailing.mas_equalTo(self.mas_trailing).offset(-20);
            make.centerY.mas_equalTo(self);
        }];
        
        //此时获取的self.autolayoutSubview.bounds还是(origin = (x = 0, y = 0), size = (width = 0, height = 0))，这里调用完页面上看不到视图
//        [self.autolayoutSubview setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];

    //OK
    [self.autolayoutSubview setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //视图自己设置圆角
    [self setCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
    
    //放在这里OK
    [self.autolayoutSubview setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
}

//- (void)layoutSublayersOfLayer:(CALayer *)layer {
//    [super layoutSublayersOfLayer:layer];
//    //放在这里OK，但是这里会调用多次，貌似不太合适放在这里
//    [self.autolayoutSubview setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//}

@end
