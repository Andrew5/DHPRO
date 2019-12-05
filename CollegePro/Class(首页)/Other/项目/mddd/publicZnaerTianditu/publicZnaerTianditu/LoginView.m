//
//  LoginView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "LoginView.h"
#import "Constants.h"
#import "ValiPhoneViewController.h"
#import "BaseNavigationController.h"
@implementation LoginView


-(void)layoutView:(CGRect)frame
{
  
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo.png"]];
    
    logoImage.frame = CGRectMake((frame.size.width - 126)/2, self.NavigateBarHeight, 126, 133);
    
    [self addSubview:logoImage];
    
    UIView *inputbg = [[UIView alloc]initWithFrame:CGRectMake(20, [self relativeY:logoImage.frame withOffY:20], frame.size.width - 40, 120)];
    
    inputbg.backgroundColor = [UIColor whiteColor];
    
    inputbg.alpha = 0.7;
    
    inputbg.layer.masksToBounds = YES;
    
    inputbg.layer.cornerRadius = 5.0f;
    
    UIImageView *accountImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"input_icon_1.png"]];
    
    accountImage.frame = CGRectMake(30, 20, 20, 20);
    
    [inputbg addSubview:accountImage];
    
    self.tfLoginName = [[UITextField alloc]initWithFrame:CGRectMake(80, 20, inputbg.frame.size.width - 100, 20)];
    
    self.tfLoginName.placeholder = @"请输入登录名";
    
    self.tfLoginName.textColor = [UIColor blackColor];
    
    self.tfLoginName.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfLoginName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [inputbg addSubview:self.tfLoginName];
    
    UIView *inputSepLine = [[UIView alloc]initWithFrame:CGRectMake(10, 60, inputbg.frame.size.width - 20, 1)];
    
    inputSepLine.backgroundColor = [self retRGBColorWithRed:169 andGreen:207 andBlue:242];
    
    [inputbg addSubview:inputSepLine];
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"input_icon_2.png"]];
    
    pwdImage.frame = CGRectMake(30, 80, 20, 20);

    [inputbg addSubview:pwdImage];
    
    self.tfPassWord = [[UITextField alloc]initWithFrame:CGRectMake(80, 80, inputbg.frame.size.width - 100, 20)];
    
    self.tfPassWord.placeholder = @"请输入密码";
    
    self.tfPassWord.secureTextEntry = YES;
    
    self.tfPassWord.textColor = [UIColor blackColor];
    
    self.tfPassWord.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [inputbg addSubview:self.tfPassWord];
    
    [self addSubview:inputbg];
    
    self.btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnLogin.frame = CGRectMake(20, [self relativeY:inputbg.frame withOffY:25], frame.size.width - 40, 45);
    
    self.btnLogin.backgroundColor = [self retRGBColorWithRed:0 andGreen:166 andBlue:243];
    
    self.btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnLogin setTitle:@"登  录" forState:UIControlStateNormal];
    
    self.btnLogin.layer.masksToBounds = YES;
    
    self.btnLogin.layer.cornerRadius = 5.0f;
    
    [self.btnLogin addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnLogin];
    
    self.btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnRegister.frame = CGRectMake(25, frame.size.height - 50, 80, 35);
    
    self.btnRegister.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [self.btnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnRegister setTitle:@"注 册" forState:UIControlStateNormal];
    
    self.btnRegister.layer.borderColor = [[self retRGBColorWithRed:64 andGreen:145 andBlue:242] CGColor];
    
    self.btnRegister.layer.borderWidth = 1.0f;
    
    self.btnRegister.layer.masksToBounds = YES;
    
    self.btnRegister.layer.cornerRadius = 3.0f;
    
    [self.btnRegister addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnRegister];
    

    self.btnForgetPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnForgetPwd.frame = CGRectMake(frame.size.width - 25 - 100, frame.size.height - 50, 80, 35);
    
    self.btnForgetPwd.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    [self.btnForgetPwd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnForgetPwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    [self addSubview:self.btnForgetPwd];
}

-(void)doRegister
{
    ValiPhoneViewController *valiVC = [[ValiPhoneViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:valiVC];
    
    [self.controller presentViewController:nav animated:YES completion:nil];
}

@end
