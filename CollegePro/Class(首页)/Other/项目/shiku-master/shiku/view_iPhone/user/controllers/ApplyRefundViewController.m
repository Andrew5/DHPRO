//
//  ApplyRefundViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/9/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "ApplyRefundViewController.h"

@interface ApplyRefundViewController ()

@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)makeaphonecall:(UIButton *)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://400-609-7766"]];
}
@end
