//
//  RegisterViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserManagerHandler.h"
#import "SVProgressHUD.h"
#import "CocoaSecurity.h"
#import "VerifyUtil.h"
#import "MainTabBarController.h"
@interface RegisterViewController()
{
    UserManagerHandler *_handler;
    NSString *_phoneNum;
}
@end

@implementation RegisterViewController

-(void)loadView
{
    [super loadView];
    
    self.registerView = [[RegisterView alloc]initWithController:self];
    
    [self.view addSubview:self.registerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"新用户注册"];
    
    [self buttonDoSometing];
    
    _handler = [[UserManagerHandler alloc]init];
    __unsafe_unretained RegisterViewController *safeself=self;
    _handler.successBlock = ^(id obj){
        NSLog(@"注册成功");
        [safeself presentViewController:[[MainTabBarController alloc]init] animated:YES completion:nil];
    };
}

//按钮事件
-(void)buttonDoSometing
{
    __unsafe_unretained RegisterViewController *safeself = self;
    
    self.registerView.btnClickBlack = ^(UIButton *btn){
        if (btn == safeself.registerView.btnFinish) {
            
            [safeself hideKeyBoard];
            
            NSString *nick = safeself.registerView.tfNick.text;
            NSString *pwd = safeself.registerView.tfPwd.text;
            NSString *repwd = safeself.registerView.tfRePwd.text;
            NSString *sexStr = safeself.registerView.btnMan.selected ? @"1" : @"0";
        /*
            if (![VerifyUtil validateNickname:nick]) {
                [SVProgressHUD showErrorWithStatus:@"请输入1-12个字符昵称"];
                return;
            }*/
            
            if (nick.length ==0) {
                [SVProgressHUD showErrorWithStatus:@"昵称为空,请重新输入"];
                return;
            }
            

        
            
            if(![VerifyUtil validatePassword:pwd]){
                [SVProgressHUD showErrorWithStatus:@"请输入6-20个字母或数字的密码"];
                return;
            }
            
            if (repwd == nil || repwd.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
                return;
            }
            
            if (![repwd isEqualToString:pwd]) {
                [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
                return;
            }
            
            CocoaSecurityResult *cocaSecurity = [CocoaSecurity sha1:pwd];
            NSString *shaPwd = cocaSecurity.hex;//这里需要SHA-1加密
            
            NSDictionary *params = @{@"loginName":safeself->_phoneNum , @"userPassword":shaPwd, @"userSex":sexStr, @"phone" : safeself->_phoneNum , @"nickName":nick};
            //开始注册
            [safeself -> _handler doRegisterWithParams:params];
        }
    };
}

//隐藏键盘
-(void)hideKeyBoard
{
    
    [self.registerView.tfNick resignFirstResponder];
    [self.registerView.tfPwd resignFirstResponder];
    [self.registerView.tfRePwd resignFirstResponder];
    
}

- (void)setValue:(NSObject *)value
{
    _phoneNum = (NSString *)value;
}

@end
