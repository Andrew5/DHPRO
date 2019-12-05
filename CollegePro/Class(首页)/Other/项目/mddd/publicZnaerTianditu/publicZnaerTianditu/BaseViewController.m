//
//  BaseViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/2.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "MainTabBarController.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "MobClick.h"
#import "UserManagerHandler.h"
//#import "XGPush.h"

@class AppDelegate;

@interface BaseViewController ()
{
    UILabel *_titleText;
}
@end

@implementation BaseViewController

-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNav];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:LOGOUT_NOTIF object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



//退出登陆
-(void)logout:(NSNotification *)notification{
    NSDictionary *userInfo = notification.object;
   // NSString *loginName = [userInfo objectForKey:@"loginName"];
    NSString *msg = [userInfo objectForKey:@"message"];
 
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}



-(void)customNav{
    UIImage *naviBg = [UIImage imageNamed:@"top_bg.png"];
    naviBg = [naviBg imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    //设置导航栏背景
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    [navBar setBackgroundImage:naviBg forBarMetrics:UIBarMetricsDefault];
    
    _titleText = [[UILabel alloc] initWithFrame: CGRectMake(160, 0, 120, 50)];
    _titleText.backgroundColor = [UIColor clearColor];
    _titleText.textColor=[UIColor whiteColor];
    [_titleText setFont:[UIFont boldSystemFontOfSize:20.0]];
    _titleText.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=_titleText;
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftBtn setImage:[UIImage imageNamed:@"back_bt1.png"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back_bt2.png"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

-(void)leftBack{
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitle:(NSString *)title{
    _titleText.text = title;
}

-(void)setNavRight:(UIView *)rightView{
    
}

-(void)setNavLeft:(UIView *)leftView{
    
}

-(void)hideLeftBackBtn{
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)hideTabBar{
    [(MainTabBarController *)self.tabBarController hideTabBar];
}

-(void)showTabBar{
    [(MainTabBarController *)self.tabBarController showTabBar];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:^{
            UserManagerHandler *handler = [[UserManagerHandler alloc]init];
            [handler doLoginOut];//清空所有数据
            //注销别名推送
//            [XGPush setAccount:@"*"];
            
        }];
   
    }
}

@end
