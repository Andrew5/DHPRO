//
//  LoginViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "CocoaSecurity.h"
#import "UserManagerHandler.h"
#import "UserEntity.h"
#import "MainTabBarController.h"
//#import "XGPush.h"
#import "Constants.h"

@interface LoginViewController ()
{
    UserManagerHandler *_handler;
}
@end

@implementation LoginViewController

-(void)loadView
{
    [super loadView];

    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    bgBtn.frame = self.view.frame;
    
    UIImage *image = [UIImage imageNamed:@"login_bg.png"];
    
    [bgBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    self.loginView = [[LoginView alloc]initWithController:self];
    
    [bgBtn addSubview:self.loginView];
    
    self.view = bgBtn;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _handler = [[UserManagerHandler alloc]init];
    __unsafe_unretained LoginViewController *safeSelf = self;
    _handler.successBlock = ^(id obj){
        //这里登陆成功后跳转
        [safeSelf presentViewController:[[MainTabBarController alloc]init] animated:YES completion:nil];
    };
    
    __unsafe_unretained LoginViewController *safeself = self;
    self.loginView.btnClickBlack = ^(UIButton *btn){
      
        if (btn == safeself.loginView.btnLogin) {
            
            [safeself.loginView.tfLoginName resignFirstResponder];
            [safeself.loginView.tfPassWord resignFirstResponder];
            
            NSString *loginName = safeself.loginView.tfLoginName.text;
            NSString *password = safeself.loginView.tfPassWord.text;
            if (loginName == nil || loginName.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入登录名"];
                return;
            }
            if (password == nil || password.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入密码"];
                return;
            }
            
            
            CocoaSecurityResult *cocaSecurity = [CocoaSecurity sha1:password];
            NSString *shaPwd = cocaSecurity.hex;//这里需要SHA-1加密
            
            NSDictionary *params = @{@"loginName":loginName , @"password":shaPwd};
            
            //开始登录
            [safeself -> _handler doLoginWithParams:params];
            
        }
    };
}





@end
