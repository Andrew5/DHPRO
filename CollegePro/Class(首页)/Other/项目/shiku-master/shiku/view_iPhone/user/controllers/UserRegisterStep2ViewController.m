//
//  UserRegisterStep2ViewController.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserRegisterStep2ViewController.h"
#import "UserRegisterStep3ViewController.h"

@interface UserRegisterStep2ViewController ()

@end

@implementation UserRegisterStep2ViewController
-(instancetype)initWithRestPsw:(BOOL)isRestPsw
{
    self=[super init];
    if (self) {
        isInitWithRestPse=isRestPsw;
    }
    return self;
}
-(instancetype)initModefiyPsw:(BOOL)isModefiyPsw
{
    self=[super init];
    if (self) {
        isInitWithModifyPse=isModefiyPsw;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backend=[UserBackend shared];
    
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    if (isInitWithRestPse) {
        self.usernameField.secureTextEntry=NO;
        self.usernameViewWidth.constant=0;
        self.userNameLabel.text=@"昵称      ";
        self.title=@"用户注册";
        self.usernameField.placeholder=@"请输入昵称";
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if(isInitWithModifyPse)
    {
        self.usernameField.secureTextEntry=YES;
        self.userNameLabel.text=@"原有密码";
        self.usernameField.placeholder=@"请输入原有密码";
        self.title=@"修改密码";
        [self.loginBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    }
    else{
        self.usernameField.secureTextEntry=NO;
        self.userNameLabel.text=@"昵称      ";
        self.usernameField.placeholder=@"请输入昵称";
        self.title=@"用户注册";
        [self.loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    self.loginBtn.backgroundColor=MAIN_COLOR;
    self.loginBtn.layer.cornerRadius=5;
    [self.loginBtn setTintColor:WHITE_COLOR];
    
    self.userPassworLabel.secureTextEntry=YES;
    self.validationLabel.secureTextEntry=YES;
    
    self.user=[[App shared] currentUser];
}
- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if (textField.text.length==11) {
        [self.loginBtn setBackgroundColor:MAIN_COLOR];
        [self.loginBtn setTintColor:TEXT_COLOR_DARK];
    }
    else
    {
        [self.loginBtn setBackgroundColor:BG_COLOR];
        [self.loginBtn setTintColor:WHITE_COLOR];
    }
}

-(void)goBack
{
    if (isInitWithRestPse) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)loginBtnTapped:(id)sender {
    NSLog(@"user.tele --%@",self.user.tele);
    self.user.name=self.usernameField.text;
    self.user.password=[CocoaSecurity md5:self.userPassworLabel.text].hexLower;
    self.user.newpassword=[CocoaSecurity md5:self.usernameField.text].hexLower;
    if ([self.userPassworLabel.text isEqualToString:self.validationLabel.text]&&self.userPassworLabel.text.length>0&&self.userPassworLabel.text.length>0)
    {
        [self.view showHUD:@"成功" afterDelay:1];
        //注册
        [[self.backend requestRegister:self.user]
         subscribeNext:[self didGetUserInfoSuccess]];
    }
    else
    {
        [self.view showHUD:@"两次密码必须一样" afterDelay:1];
    }
    
    if(isInitWithRestPse){
        [[self.backend requestResetPsw:self.user]
            subscribeNext:[self didUpdate]];
    }
    else if(isInitWithModifyPse)
    {
        [[self.backend requestChangePsw:self.user]
         subscribeNext:[self didUpdate]];
    }
    else{
        if (self.usernameField.text.length>0) {
        }
        else{
            [self.view showHUD:@"昵称不能为空" afterDelay:1];
        }
       
    }
    
   
}
- (void(^)(RACTuple *))didUpdate
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:@"操作成功" afterDelay:2];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:1];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    };
}

- (void(^)(USER *))didGetUserInfoSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self.view showHUD:@"手机号已经被注册！" afterDelay:2];
        }else{
            [[App shared] setCurrentUser:user];
            [self.backend.repository storage:user];
            UserRegisterStep3ViewController *r3=[UserRegisterStep3ViewController new];
            [self.navigationController pushViewController:r3 animated:YES];

//            if ([self.delegate respondsToSelector:@selector(authencateUserSuccess:authController:)]) {
//                [self.delegate authencateUserSuccess:user authController:self];
//            }
//            else{
//                [self goBack];
//            }
        }
    };
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
