//
//  loginViewController.m
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/6.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import "loginViewController.h"
#import "loginInterface.h"
#import "registerViewController.h"
@interface loginViewController ()
@property(nonatomic, strong) loginInterface *loginView;

@end

@implementation loginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLoginInterface];
    
}
- (void)loadLoginInterface
{
    
    _loginView = [loginInterface loadLoginView];
    _loginView.frame = self.view.frame;
    [_loginView btnClicked:^(SFBtnlogin button) {
        switch ((NSInteger)button) {
            case login:
                NSLog(@"login succeed");
                break;
            case registerBtn: {
                registerViewController *registVC = [[registerViewController alloc] init];
                [self presentViewController:registVC animated:YES completion:nil];
                break;
            }
                case forgetBtn:
                NSLog(@"forger password ");
                break;
            case facebook:
                NSLog(@"facebook login succeed ");
                break;
            case google:
                NSLog(@"google login succeed ");
                break;
            case skip:
                NSLog(@"skip now ");
                break;
            default:
                break;
        }

    }];
    [self.view addSubview:_loginView];
}


@end
