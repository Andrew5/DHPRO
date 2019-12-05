//
//  UserRegisterStep3ViewController.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserRegisterStep3ViewController.h"

@interface UserRegisterStep3ViewController ()

@end

@implementation UserRegisterStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"注册成功";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    self.loginBtn.backgroundColor=MAIN_COLOR;
    self.loginBtn.layer.cornerRadius=5;
    [self.loginBtn setTintColor:WHITE_COLOR];
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

- (IBAction)loginBtnTapped:(id)sender {
    [self goBack];
}
@end
