//
//  callViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/8/2.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "callViewController.h"

@interface callViewController ()

@end

@implementation callViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self addTitleViewWithTitle:@"联系我吧"];
    //[self addBarButtonItem:nil image:[UIImage imageNamed:@"webview_back"] target:self action:@selector(btnLeftClick) isLeft:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 50, 50);
    [button setImage:[UIImage imageNamed:@"login_close_icon@3x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageV.image = [UIImage imageNamed:@"call"];
    [self.view addSubview:imageV];
    [self.view addSubview:button];
}
-(void)btnLeftClick
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
