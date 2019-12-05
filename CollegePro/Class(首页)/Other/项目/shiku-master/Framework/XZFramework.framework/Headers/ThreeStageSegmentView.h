//
//  ThreeStageSegmentView.h
//  btc
//
//  Created by txj on 15/1/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/TView.h>
#import "TConfig.h"

@class ThreeStageSegmentView;

@protocol ThreeStageSegmentViewDelegate <NSObject>
- (void)threeStageSegmentView:(ThreeStageSegmentView *)segment
             didSelectAtIndex:(NSInteger)index;
@end

@interface ThreeStageSegmentView : TView

@property (strong, nonatomic) UIView *indicatorView;
@property (strong, nonatomic) UIColor *spliteColor;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (strong, nonatomic) UIButton *newsButton;
@property (strong, nonatomic) UIButton *lowButton;
@property (strong, nonatomic) UIButton *highButton;
@property (strong, nonatomic) UIButton *priceButton;
@property (strong, nonatomic)
id<ThreeStageSegmentViewDelegate> delegate;
@property (assign, nonatomic) NSInteger selectedIndex;
-(id)initWithOutIndicatorView:(CGRect)frame;
-(id)initWithButtonsName:(NSArray *)btnsName frame:(CGRect)frame;

- (void)changeSelectedIndex:(NSInteger)index;

//ThreeStageSegmentView *tssView=[[ThreeStageSegmentView alloc] initWithButtonsName:@[@"全部订单",@"已支付",@"已完成"] frame:CGRectMake(0, 0,screenSize.width, 40)];
//tssView.delegate=self;
//tssView.backgroundColor=BG_COLOR;
@end

