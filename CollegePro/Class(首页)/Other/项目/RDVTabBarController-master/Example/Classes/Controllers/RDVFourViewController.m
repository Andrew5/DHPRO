//
//  RDVFourViewController.m
//  RDVTabBarController
//
//  Created by Rillakkuma on 2016/10/18.
//  Copyright © 2016年 Robert Dimitrov. All rights reserved.
//

#import "RDVFourViewController.h"

@interface RDVFourViewController ()

@end

@implementation RDVFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [[UIScreen mainScreen] bounds].size.width,44)];
    navLabel.backgroundColor = [UIColor grayColor];       //背景颜色
    navLabel.textColor = [UIColor blackColor];             //字体颜色 默认为RGB 0,0,0
    navLabel.numberOfLines = 0;                            //行数 0为无限 默认为1
    navLabel.textAlignment = NSTextAlignmentCenter;        //对齐方式 默认为左对齐
    navLabel.font = [UIFont systemFontOfSize:12];          //设置字体及字体大小
    navLabel.text = @"背景颜色";
    
    
    self.navigationController.navigationBar.topItem.titleView = navLabel;
    //设置显示内容
    //    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    self.navigationController.navigationBar.translucent=YES;
    
    
    
    // Do any additional setup after loading the view.
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
