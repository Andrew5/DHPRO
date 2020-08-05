//
//  WKNavView.m
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKNavView.h"
@interface WKNavView ()
@property (nonatomic,strong) UIButton * leftBtn;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * line;
@end
@implementation WKNavView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, WK_SCREEN_WIDTH, WK_NAVIGATION_STATUS_HEIGHT )];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self addSubview:self.line];
    }
    return self;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
//        BOOL isWarnning = [WKVCDeallocManger sharedVCDeallocManager].isWarnning;
//        [_rightBtn setTitle: isWarnning ? @"关闭警告" : @"开启警告" forState:(UIControlStateNormal)];

        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _rightBtn.frame = CGRectMake(WK_SCREEN_WIDTH - 100, 20, 100, 44);
        _rightBtn.tag = 101;
    }
    return _rightBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = CGRectMake(CGRectGetMidX(self.frame) - 50, 20, 100, 44);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _leftBtn.frame = CGRectMake(0, 20, 60, 44);
        _leftBtn.tag = 100;
        
    }
    return _leftBtn;
}


- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WK_SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1];
    }
    return _line;
}

- (void)buttonClick:(UIButton *)btn
{
    switch (btn.tag - 100) {
        case 0:
            if (_delegate && [_delegate respondsToSelector:@selector(backItemClick)]) {
                [_delegate backItemClick];
            }
            break;
            
        default:
            if (_delegate && [_delegate respondsToSelector:@selector(detailItemClick)]) {
                [_delegate detailItemClick];
            }
            break;
    }
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setBackTitle:(NSString *)backTitle
{
    _backTitle = backTitle;
    [self.leftBtn setTitle:backTitle forState:(UIControlStateNormal)];
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    [self.rightBtn setTitle:detailTitle forState:(UIControlStateNormal)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
