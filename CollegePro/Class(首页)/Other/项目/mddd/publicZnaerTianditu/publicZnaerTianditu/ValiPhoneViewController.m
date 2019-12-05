//
//  ValiPhoneViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "ValiPhoneViewController.h"
#import "RegisterViewController.h"
#import "VerifyUtil.h"
#import "SVProgressHUD.h"
#import "UserManagerHandler.h"

#define TIME_OUT_INTERVAL 120 //验证码过期时效

@interface ValiPhoneViewController ()
{
    UserManagerHandler *_handler;
    NSTimer            *_timer;
    NSString           *_valiCode;
    int                 _countSec;
}
@end

@implementation ValiPhoneViewController

-(void)loadView
{
    [super loadView];
    
    self.valiPhoneView = [[ValiPhoneView alloc]initWithController:self];

    [self.view addSubview:self.valiPhoneView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"新用户注册"];
    
    UIBarButtonItem *leftItem = self.navigationItem.leftBarButtonItem;
    UIButton *leftBtn = (UIButton *)leftItem.customView;
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self buttonDoSometing];
    
    _handler = [[UserManagerHandler alloc]init];
    
    __unsafe_unretained ValiPhoneViewController *safeSelf = self;
    
    _handler.successBlock = ^(id obj){
        
        safeSelf -> _valiCode = [obj objectForKey:@"code"];
        
        safeSelf -> _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:safeSelf selector:@selector(doCountDown) userInfo:nil repeats:YES];
        
    };

    _countSec = TIME_OUT_INTERVAL;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
    _countSec = TIME_OUT_INTERVAL;
    [self.valiPhoneView.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)doCountDown{
    
    _countSec --;
    
    if (_countSec > 0) {
        
        NSString *btnTitle;
        if (_countSec < 10) {
            btnTitle = [NSString stringWithFormat:@"已发送(0%ds)",_countSec];
        }
        else{
            btnTitle = [NSString stringWithFormat:@"已发送(%ds)",_countSec];
        }
        
        [self.valiPhoneView.btnCode setTitle:btnTitle forState:UIControlStateNormal];
        [self.valiPhoneView.btnCode setEnabled:NO];
        [self.valiPhoneView.btnCode setAlpha:0.6f];
    }
    else{
        [_timer invalidate];
        _timer = nil;
        _countSec = TIME_OUT_INTERVAL;
        [self.valiPhoneView.btnCode setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.valiPhoneView.btnCode setEnabled:YES];
        [self.valiPhoneView.btnCode setAlpha:1.0f];
    }
    
}


//按钮事件
-(void)buttonDoSometing
{
    
    __unsafe_unretained ValiPhoneViewController *safeself = self;
    
    self.valiPhoneView.btnClickBlack = ^(UIButton *btn){
        
        [safeself.valiPhoneView.tfNum resignFirstResponder];
        
        [safeself.valiPhoneView.tfCode resignFirstResponder];
        
        NSString *num = safeself.valiPhoneView.tfNum.text;
        
        if (![VerifyUtil validateMobile:num]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
            return;
        }
        
        if (btn == safeself.valiPhoneView.btnNext) {
          
            NSString *codeStr = safeself.valiPhoneView.tfCode.text;
            
            if (codeStr.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            
            if (safeself->_valiCode.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"您还未获取验证码"];
                return;
            }
            
            if (![codeStr isEqualToString:safeself->_valiCode]) {
                [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
                return;
            }
            
            if (safeself.valiPhoneView.btnCode.enabled) {
                [SVProgressHUD showErrorWithStatus:@"验证码已过期"];
                return;
            }
            
                      
            RegisterViewController *registerVC = [[RegisterViewController alloc]init];
            safeself.passDelegate = registerVC;
            [safeself.navigationController pushViewController:registerVC animated:YES];
            [safeself.passDelegate setValue:num];
        }
        else if (btn == safeself.valiPhoneView.btnCode){
            //获取验证码
            [safeself->_handler doValidatePhone:num];
        }
    };
}



-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
