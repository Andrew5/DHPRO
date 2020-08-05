//
//  TodayTableHeaderView.m
//  CollegeProExtension
//
//  Created by jabraknight on 2019/5/27.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "TodayTableHeaderView.h"
@interface TodayTableHeaderView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@end


@implementation TodayTableHeaderView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
        // 布局子视图
        [self mas_layoutSubviews];
    }
    return self;
}
- (void)mas_layoutSubviews{
    
    self.imageView.frame = CGRectMake(50, 0, 50, 98);
    self.label.frame = CGRectMake(self.imageView.frame.origin.x+self.imageView.frame.size.width + 10 , self.imageView.center.y-10, 100, 20);
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_offset(15.0);
//        make.bottom.mas_offset(-15.0);
//        make.height.mas_equalTo(80.0);
//        make.width.mas_equalTo(70.0);
//    }];
//
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.imageView);
//        make.left.equalTo(self.imageView.mas_right).mas_offset(10.0);
//    }];
}
#pragma mark - lazy load
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"精灵球"];
        _imageView.layer.cornerRadius = 8.0;
        _imageView.layer.borderColor = [UIColor blackColor].CGColor;
        _imageView.layer.borderWidth = 1.0;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"我是标题98像素";
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
