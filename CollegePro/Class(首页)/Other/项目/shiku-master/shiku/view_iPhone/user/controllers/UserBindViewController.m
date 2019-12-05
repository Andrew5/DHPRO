//
//  UserBindViewController.m
//  btc
//
//  Created by txj on 15/3/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserBindViewController.h"
#import <CocoaSecurity.h>
@interface UserBindViewController ()

@end

@implementation UserBindViewController
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.backend = [UserBackend shared];
    }
    return self;
}
-(instancetype)initWithUserMode:(USER *)user
{
    self=[self init];
    self.user=user;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"手机号绑定";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.view.backgroundColor=BG_COLOR;
    self.lbtitle.textColor=MAIN_COLOR;
    self.vsplit.backgroundColor=BG_COLOR;
    [self.haveAccount setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.registerNewAccount setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    
    self.vuserinfo.layer.cornerRadius=5;
    
    self.lbusername.text=@"\U0000E61C";
    self.lbusername.textAlignment=NSTextAlignmentLeft;
    self.lbusername.font=[UIFont fontWithName:@"LLiconfont" size:30];
    self.lbusername.textColor=[UIColor colorWithWhite:0.651 alpha:1.000];
    
    self.lbpassword.text=@"\U0000E642";
    self.lbpassword.textAlignment=NSTextAlignmentLeft;
    self.lbpassword.font=[UIFont fontWithName:@"LLiconfont" size:30];
    self.lbpassword.textColor=[UIColor colorWithWhite:0.651 alpha:1.000];
    
    self.tvusername.placeholder=@"请输入11位手机号";
    self.tvpassword.placeholder=@"请输入6位数以上密码";
    self.tvpassword.secureTextEntry=YES;
    
    if (!self.user) {
        self.user=[USER new];
    }
    
    //self.user=[[UserAuthenticationModel alloc] init];
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

- (IBAction)haveAccountTapped:(id)sender {
    
//    if (self.tvusername.text.length==11&&self.tvpassword.text.length>=3) {
        self.user.name=self.tvusername.text;
        self.user.password=[CocoaSecurity md5:self.tvpassword.text].hexLower;
        
        NSError *error = [self.user valid];
        if (nil == error||error.code==-1) {
            [[self.backend requestAuthenticate:self.user]
             subscribeNext:[self didAuthencateUserSuccess]
             error:[self didAuthencateUserFailure]];
        }
//        
//    }
//    else
//    {
//        [self.view showHUD:@"手机号或密码格式不对" afterDelay:1];
//    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.tvusername resignFirstResponder];
    [self.tvpassword resignFirstResponder];
}
- (IBAction)registerAccountTapped:(id)sender {
    if (self.tvusername.text.length==11&&self.tvpassword.text.length>=3) {
        
        self.user.name=self.tvusername.text;
        
        
        //        if (model.username.length==11) {
        //            if (self.password.text.length>=6) {
        self.user.password=[CocoaSecurity md5:self.tvpassword.text].hexLower;
        [[self.backend requestRegister:self.user]
         subscribeNext:[self didRegisterUserSuccess]
         error:[self didAuthencateUserFailure]];
        //            }
        //            else
        //            {
        //                [self.view showHUD:@"密码必须6位以上" afterDelay:1];
        //            }
        //        }
        //        else
        //        {
        //            [self.view showHUD:@"手机号必须为11位数字" afterDelay:1];
        //        }
        
    }
    else
    {
        [self.view showHUD:@"手机号或密码格式不对" afterDelay:1];
    }
}

- (void(^)(USER *))didRegisterUserSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self.view showHUD:@"该手机号已经被注册！" afterDelay:1];
        }
        else{
            [[self.backend requestAuthenticateUserBindAdd:self.user]
             subscribeNext:[self didBindUserSuccess]
             error:[self didAuthencateUserFailure]];
            if ([self.delegate respondsToSelector:@selector(finishBindUser:bindController:)]) {
                [self.delegate finishBindUser:user bindController:self];
            }
            else{
                [self goBack];
            }
        }
        
    };
}

- (void(^)(USER *))didAuthencateUserSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self.view showHUD:@"手机号或密码错误" afterDelay:1];
        }
        else{
            [[App shared] setCurrentUser:user];
            [self.backend.repository storage:user];
            [[self.backend requestAuthenticateUserBindAdd:self.user]
             subscribeNext:[self didBindUserSuccess]
             error:[self didAuthencateUserFailure]];
            if ([self.delegate respondsToSelector:@selector(finishBindUser:bindController:)]) {
                [self.delegate finishBindUser:user bindController:self];
            }
            else{
                [self goBack];
            }
        }
        
    };
}
- (void(^)(USER *))didBindUserSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self.view showHUD:@"该手机号码已被注册过" afterDelay:1];
        }
        else{
            //            if ([self.delegate respondsToSelector:@selector(finishRegisterUser:registerController:)]) {
            //                [self.delegate finishRegisterUser:user registerController:self];
            //            }
            //            else{
            //                [self goBack];
            //            }
        }
        
    };
}

- (void(^)(NSError *))didAuthencateUserFailure
{
    return ^(NSError *error) {
        [self.view showHUD:error.localizedDescription afterDelay:1];
    };
}

@end
