//
//  ESMTestViewController.m
//  HomeKit
//
//  Created by 可米小子 on 16/10/27.
//  Copyright © 2016年 可米小子. All rights reserved.
//

#import "ESMTestViewController.h"
#import "ESMOneViewController.h"

@interface ESMTestViewController ()

@end

@implementation ESMTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"测试" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(button) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)button {

    [self.navigationController pushViewController:[[ESMOneViewController alloc]init] animated:YES];
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
