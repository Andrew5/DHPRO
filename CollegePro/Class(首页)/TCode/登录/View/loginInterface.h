//
//  loginInterface.h
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/6.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,SFBtnlogin)
{
    
    login = 10,
    registerBtn,
    forgetBtn,
    facebook,
    google,
    skip
};

typedef void(^btnClicked)(SFBtnlogin button);
@interface loginInterface : UIView
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebook;
@property (weak, nonatomic) IBOutlet UIButton *google;
@property (weak, nonatomic) IBOutlet UIButton *skip;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property(nonatomic, copy) btnClicked block;
- (void)btnClicked:(btnClicked)block;

+(instancetype)loadLoginView;

@end
