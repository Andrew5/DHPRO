//
//  registerInterface.h
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/6.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClicked)(UIButton *btn);
@interface registerInterface : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@property(nonatomic, copy) btnClicked block;
- (void)btnClicked:(btnClicked)block;
+(instancetype)loadRegisterView;
@end
