//
//  registerViewController.m
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/7.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import "registerViewController.h"
#import "registerInterface.h"
#import "IQKeyboardManager.h"
#import "SFNetWorkManager.h"

@interface registerViewController ()

@property(nonatomic, strong) registerInterface *registerView;
@end

@implementation registerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:84];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRegisterInterface];
    

}
- (void)loadRegisterInterface
{
	//http://112.74.174.20:8080/contactOne
    _registerView = [registerInterface loadRegisterView];
    _registerView.frame = self.view.frame;
    [_registerView btnClicked:^(UIButton *btn) {
        if (btn ==_registerView.backBtn) {
            [self.view endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else  {
            NSString *email = _registerView.accountTF.text;
            NSString *passWord =_registerView.passwordTF.text;
            NSString *passWord2 = _registerView.confirmPasswordTF.text;
            NSDictionary *param = NSDictionaryOfVariableBindings(email,passWord,passWord2);
            [SFNetWorkManager requestWithType:HttpRequestTypePost withUrlString:@"jsonService/user/reg.json" withParaments:@{@"email":@"abcd@163.com",@"passWord":@"sf86684461",@"passWord2":@"sf86684461"} withSuccessBlock:^(NSDictionary *object) {
                NSLog(@"%@",object);
            } withFailureBlock:^(NSError *error) {
                //
            } progress:^(float progress) {
                //
            }];
        }
    }];
    [self.view addSubview:_registerView];
}

@end
