//
//  UserRegisterStep1ViewController.h
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import "JKCountDownButton.h"
/**
 *  注册第一步
 */
@interface UserRegisterStep1ViewController : TBaseUIViewController
{
    BOOL isInitWithRestPse;
    NSString *phoneAuthCode;
}
@property (weak, nonatomic) IBOutlet UIButton *btnGetValidationCode;
- (IBAction)btnGetValidationCodeTapped:(id)sender;
@property int stateN;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *validationLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnTapped:(id)sender;

@property (strong, nonatomic) UserBackend *backend;

-(instancetype)initWithRestPsw:(BOOL)isRestPsw;


@end
