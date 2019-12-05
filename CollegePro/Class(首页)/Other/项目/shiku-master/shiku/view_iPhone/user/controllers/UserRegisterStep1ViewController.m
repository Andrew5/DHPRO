//
//  UserRegisterStep1ViewController.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserRegisterStep1ViewController.h"
#import "UserRegisterStep2ViewController.h"

@interface UserRegisterStep1ViewController ()

@end

@implementation UserRegisterStep1ViewController
-(instancetype)initWithRestPsw:(BOOL)isRestPsw
{
    self=[super init];
    if (self) {
        isInitWithRestPse=isRestPsw;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_stateN == 12) {
        self.title=@"买家注册";
    }
    else{
        self.title=@"找回密码";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    
    
    self.navigationItem.leftBarButtonItem=[self tbarBackButtonWhite];
    
    self.loginBtn.backgroundColor=BG_COLOR;
    self.loginBtn.layer.cornerRadius=5;
    [self.loginBtn setTintColor:TEXT_COLOR_DARK];
    
    [self.usernameLabel addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.btnGetValidationCode.backgroundColor=MAIN_COLOR;
    self.btnGetValidationCode.layer.cornerRadius=5;
    [self.btnGetValidationCode setTintColor:WHITE_COLOR];
   
    self.backend=[UserBackend shared];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callKeyboard)];
    [self.view addGestureRecognizer:tap];

}
-(void)callKeyboard{
    [self.view endEditing:YES];
}
- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if ([self validateMobile:textField.text]) {
        [self.loginBtn setBackgroundColor:MAIN_COLOR];
        [self.loginBtn setTintColor:TEXT_COLOR_DARK];
    }
    else
    {
        [self.loginBtn setBackgroundColor:BG_COLOR];
        [self.loginBtn setTintColor:WHITE_COLOR];
    }
}

- (IBAction)loginBtnTapped:(id)sender {
    if ([self validateMobile:self.usernameLabel.text]) {
        if ([self.validationLabel.text isEqualToString:phoneAuthCode]) {
            USER *u=[USER new];
            NSString *s=self.usernameLabel.text;
            u.tele=[[NSNumber alloc] initWithInteger:[s integerValue]];
//            u.teleStr= [NSNumber numberWithDouble:[s doubleValue]];
            [[App shared] setCurrentUser:u];
            UserRegisterStep2ViewController *r2=[[UserRegisterStep2ViewController alloc] initWithRestPsw:isInitWithRestPse];
            [self.navigationController pushViewController:r2 animated:YES];

        }
        else{
            [self.view showHUD:@"验证码错误" afterDelay:1];
        }
        
    }
    else{
        [self.view showHUD:@"请输入11位手机号码" afterDelay:1];
    }
    //    USER *u=[USER new];
//    u.name=self.usernameLabel.text;
//    u.password=[CocoaSecurity md5:self.userPassworLabel.text].hexLower;
//    u.name=@"123";
//    u.password=[CocoaSecurity md5:@"123"].hexLower;
//    [[self.backend requestAuthenticate:u]
//     subscribeNext:[self didGetUserInfoSuccess]];
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

- (IBAction)btnGetValidationCodeTapped:(JKCountDownButton *)sender {
    
    if ([self validateMobile:self.usernameLabel.text]) {
    USER *u=[USER new];
//    u.teleStr= self.usernameLabel.text;// [NSNumber numberWithDouble:[self.usernameLabel.text doubleValue]];
    u.tele=  [NSNumber numberWithInteger:[self.usernameLabel.text integerValue]];
    [[self.backend requestPhoneCode:u] subscribeNext:^(id x) {
        ResponseResult *d=(ResponseResult *)x;
        phoneAuthCode= [[d.data objectForKey:@"code"] stringValue];
//        [self.view showHUD:phoneAuthCode afterDelay:1];
        
    }];
    sender.enabled = NO;
    self.btnGetValidationCode.backgroundColor=TEXT_COLOR_LIGHT;
    
    //button type要 设置成custom 否则会闪动
    [sender startWithSecond:60];
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"获取验证码(%d)",second];
        [self.btnGetValidationCode setTitleColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.0] forState:UIControlStateNormal];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        self.btnGetValidationCode.backgroundColor=MAIN_COLOR;
        [self.btnGetValidationCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return @"重新获取";
        
    }];
    }
    else
    {
        [self.view showHUD:@"请输入正确的手机号" afterDelay:1];
    }

    
}
@end
