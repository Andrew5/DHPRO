//
//  UserRegisterStep2ViewController.h
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import <CocoaSecurity.h>
/**
 *  注册第二步
 */
@interface UserRegisterStep2ViewController : TBaseUIViewController
{
    BOOL isInitWithRestPse;
    BOOL isInitWithModifyPse;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelConstant;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *userPassworLabel;
@property (weak, nonatomic) IBOutlet UITextField *validationLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (strong, nonatomic) USER *user;
@property (strong, nonatomic) UserBackend *backend;

-(instancetype)initWithRestPsw:(BOOL)isRestPsw;
-(instancetype)initModefiyPsw:(BOOL)isModefiyPsw;
@end
