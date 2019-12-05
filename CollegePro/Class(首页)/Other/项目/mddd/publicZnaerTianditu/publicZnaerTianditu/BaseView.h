//
//  BaseView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/19.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//View中按钮向外部提供接口的black 以便view和controller通信
typedef void(^ButtonClickBlack)(id obj);

//view和controller通信代理
@protocol BaseViewDelegate

-(void)btnClick:(id)obj;

@end

@interface BaseView : UIView

@property(nonatomic,strong)BaseViewController *controller;

@property(nonatomic)int NavigateBarHeight;

- (id)initWithController:(UIViewController *)controller;

-(void)layoutView:(CGRect)frame;

-(UIColor *)retRGBColorWithRed:(int)r andGreen:(int)g andBlue:(int)b;

//计算View相对位置

-(CGFloat)relativeX:(CGRect)frame withOffX:(CGFloat)dX;

-(CGFloat)relativeY:(CGRect)frame withOffY:(CGFloat)dY;

@property(nonatomic,copy)ButtonClickBlack btnClickBlack;

-(void)doAction:(UIButton *)sender;//view中按钮点击事件处理方法

@end
