//
//  LoginView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseView.h"

@interface LoginView : BaseView

@property(nonatomic,retain)UITextField *tfLoginName;
@property(nonatomic,retain)UITextField *tfPassWord;

@property(nonatomic,retain)UIButton    *btnLogin;
@property(nonatomic,retain)UIButton    *btnRegister;
@property(nonatomic,retain)UIButton    *btnForgetPwd;

@end
