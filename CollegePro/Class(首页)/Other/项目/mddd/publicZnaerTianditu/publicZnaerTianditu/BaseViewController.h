//
//  BaseViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/2.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>

//页面传值代理
@protocol PassValueDelegate

- (void)setValue:(NSObject *)value;

@end

@interface BaseViewController : UIViewController<UIAlertViewDelegate>

-(void)hideTabBar;//隐藏tabbar

-(void)showTabBar;//显示tabbar

-(void)setTitle:(NSString *)title;

-(void)setNavRight:(UIView *)rightView;

-(void)setNavLeft:(UIView *)leftView;

//隐藏左边返回按钮
-(void)hideLeftBackBtn;

@end
