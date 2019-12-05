//
//  UerLoginViewController.h
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRegisterStep1ViewController.h"
#import "UserBackend.h"

//#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "UserBindViewController.h"
///用户登录
@class UserLoginViewController;
@protocol UserLoginViewControllerDelegate <NSObject>
-(void)authencateUserSuccess:(USER *)user authController:(UserLoginViewController *)controller;
@end


@interface UserLoginViewController : TBaseUIViewController<TencentSessionDelegate,WXApiDelegate,UserBindViewControllerDelegate>
{
    TencentOAuth* _tencentOAuth;
    NSMutableArray* _qqpermissions;
    NSString *usertype;
    NSString *userkeyid;
    NSString *currentLatitude;
    NSString *currentLongitude;
    
    CLLocationManager *locManager;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;


@property (strong, nonatomic) id<UserLoginViewControllerDelegate> delegate;
/**
 * 各属性请对照.xib文件
 */
//@property (weak, nonatomic) IBOutlet UILabel *lbOtherLoginLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userPassworLabel;
@property (weak, nonatomic) IBOutlet UITextField *validationLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassworBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbwblogin;
@property (weak, nonatomic) IBOutlet UILabel *lbwxlogin;
@property (weak, nonatomic) IBOutlet UILabel *lbqqlogin;

@property (weak, nonatomic) IBOutlet UIButton *loginBtnWb;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnWx;
@property (weak, nonatomic) IBOutlet UIButton *loginBtnQQ;
- (IBAction)loginBtnWbTapped:(id)sender;//新浪微博登录按钮
- (IBAction)loginBtnWxTapped:(id)sender;//微信登录按钮
- (IBAction)loginBtnQQTapped:(id)sender;//qq登录按钮

- (IBAction)loginBtnTapped:(id)sender;//登录按钮
- (IBAction)registerBtnTapped:(id)sender;//注册按钮
- (IBAction)forgetPasswordBtnTapped:(id)sender;//忘记密码按钮
@property (weak, nonatomic) IBOutlet UIView *validationView;
@property (strong, nonatomic) UserBackend *backend;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) USER *user;

@end
