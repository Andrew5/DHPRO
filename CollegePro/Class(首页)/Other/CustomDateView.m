
//
//  CustomDateView.m
//  CunGuangYin
//
//  Created by baimifan on 15/6/29.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import "CustomDateView.h"



@implementation CustomDateView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectDate = [NSDate date];
        
        _disMissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_disMissBtn addTarget:self action:@selector(disMissBtnSelect) forControlEvents:UIControlEventTouchUpInside];
        _disMissBtn.frame = self.bounds;
        _disMissBtn.alpha = 0.1;
        _disMissBtn.backgroundColor = [UIColor blackColor];
        [self addSubview:_disMissBtn];
        
        _datePickView = [[UIDatePicker alloc]init];
        _datePickView.backgroundColor = [UIColor whiteColor];
        _datePickView.bounds = CGRectMake(0, 0, CGRectGetWidth(frame) - 30, CGRectGetWidth(frame) - 30);
        _datePickView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        _datePickView.datePickerMode = UIDatePickerModeDateAndTime;
        _datePickView.layer.cornerRadius = 5;
        _datePickView.clipsToBounds = YES;
        [_datePickView addTarget:self action:@selector(changeTime:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePickView];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_selectBtn addTarget:self action:@selector(selectBtnSeelct) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(frame) - 30, 40);
        _selectBtn.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(_datePickView.frame) + 40);
        _selectBtn.backgroundColor = [UIColor colorWithRed:48/255.0 green:165/255.0 blue:229/255.0 alpha:1.00f];
        _selectBtn.layer.cornerRadius = 8;
        _selectBtn.clipsToBounds = YES;
        [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:_selectBtn];
        
    }
    return self;
}
- (void)setMinDate:(NSDate *)minDate{
    if (_minDate != minDate) {
        _minDate = minDate;
        _datePickView.minimumDate = _minDate;
    }
}

- (void)setMaxDate:(NSDate *)maxDate{
    if (_maxDate != maxDate) {
        _maxDate = maxDate;
        _datePickView.maximumDate = _maxDate;
    }
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)changeTime:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    _selectDate = datePicker.date;
}




- (void)pickViewButtonSelectWithSelect:(pickButton)block{
    self.block = block;
}

- (void)disMissBtnSelect{
    if (self.block) {
        self.block(_selectDate);
    }

    [self removeFromSuperview];
}
- (void)selectBtnSeelct{
    if (self.block) {
        self.block(_selectDate);
    }

    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
