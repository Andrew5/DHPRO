//
//  CustomDateView.h
//  CunGuangYin
//
//  Created by baimifan on 15/6/29.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^pickButton)(NSDate *date);
@interface CustomDateView : UIView

@property (strong, nonatomic) UIButton *selectBtn;
@property (strong, nonatomic)UIButton *disMissBtn;
@property (nonatomic,strong) UIDatePicker *datePickView;

@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSDate *maxDate;
@property (nonatomic, retain) NSDate *selectDate;
@property (copy, nonatomic)pickButton block;


- (id)initWithFrame:(CGRect)frame;

- (void)pickViewButtonSelectWithSelect:(pickButton)block;

@end
