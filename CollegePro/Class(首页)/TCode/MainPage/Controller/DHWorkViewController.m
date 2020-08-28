//
//  DHWorkViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHWorkViewController.h"
#import "LilyChangeServerTypeVC.h"

@interface DHWorkViewController ()

@end

@implementation DHWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = YES;
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"确 定" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
//    [loginBtn setBackgroundImage:[UIImage imageNamed:@"自读测评蓝色色按钮_ipad"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(44);
    }];
    // Do any additional setup after loading the view.
}
- (void)sure:(UIButton *)btn
{
    LilyChangeServerTypeVC *vc = [[LilyChangeServerTypeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
