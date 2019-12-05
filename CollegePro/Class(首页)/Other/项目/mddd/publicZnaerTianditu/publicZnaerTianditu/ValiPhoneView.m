//
//  ValiPhoneView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "ValiPhoneView.h"
#import "Constants.h"
#import "RegisterViewController.h"
#import "APIConfig.h"
@implementation ValiPhoneView

@synthesize tfNum = _tfNum;
@synthesize tfCode = _tfCode;
@synthesize btnCode = _btnCode;
@synthesize btnNext = _btnNext;
@synthesize btnRead = _btnRead;

-(void)layoutView:(CGRect)frame
{

  
    self.tfNum = [[UITextField alloc]initWithFrame:CGRectMake(10, self.NavigateBarHeight + 10, frame.size.width - 20, 45)];
    
    self.tfNum.borderStyle = UITextBorderStyleRoundedRect;
    
    self.tfNum.placeholder = @"请输入手机号码";
    
    self.tfNum.textColor = [UIColor blackColor];
    
    self.tfNum.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tfNum.keyboardType = UIKeyboardTypePhonePad;
    
    self.tfNum.layer.borderColor = [[self retRGBColorWithRed:228 andGreen:228 andBlue:228] CGColor];
    
    self.tfNum.layer.borderWidth = 1.0f;
    
    self.tfNum.layer.masksToBounds = YES;
    
    self.tfNum.layer.cornerRadius = 5.0f;
    
    [self addSubview:self.tfNum];
    
    
    self.tfCode = [[UITextField alloc]initWithFrame:CGRectMake(10, [self relativeY:self.tfNum.frame withOffY:10], frame.size.width * 0.6, 45)];
    
    self.tfCode.borderStyle = UITextBorderStyleRoundedRect;
    
    self.tfCode.placeholder = @"请输入验证码";
    
    self.tfCode.textColor = [UIColor blackColor];
    
    self.tfCode.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tfCode.layer.borderColor = [[self retRGBColorWithRed:228 andGreen:228 andBlue:228] CGColor];
    
    self.tfCode.layer.borderWidth = 1.0f;
    
    self.tfCode.layer.masksToBounds = YES;
    
    self.tfCode.layer.cornerRadius = 5.0f;
    
    [self addSubview:self.tfCode];
    
    
    self.btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnCode.frame = CGRectMake([self relativeX:self.tfCode.frame withOffX:10], [self relativeY:self.tfNum.frame withOffY:10], frame.size.width * 0.4 - 30, 45);
    
    self.btnCode.backgroundColor = [self retRGBColorWithRed:57 andGreen:158 andBlue:239];
    
    [self.btnCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.btnCode.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE - 1];
    
    self.btnCode.layer.cornerRadius = 5.0f;
    
    self.btnCode.layer.masksToBounds = YES;
    
    [self.btnCode addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnCode];
    
   
    self.btnRead = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnRead.frame = CGRectMake(10, [self relativeY:self.btnCode.frame withOffY:10], 140, 20);
    
    [self.btnRead setImage:[UIImage imageNamed:@"sel_bt2.png"] forState:UIControlStateNormal];
    [self.btnRead setImage:[UIImage imageNamed:@"sel_bt1.png"] forState:UIControlStateSelected];
    
    [self.btnRead setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.btnRead.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [self.btnRead setTitle:@"我已经阅读并同意" forState:UIControlStateNormal];
    
    self.btnRead.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    self.btnRead.imageEdgeInsets = UIEdgeInsetsMake(-2, -10, 0, 0);
    
    self.btnRead.backgroundColor = [UIColor clearColor];
    
    [self.btnRead addTarget:self action:@selector(doAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRead.selected = YES;
    
    [self addSubview:self.btnRead];
    
    self.btnAgreement = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnAgreement.frame = CGRectMake([self relativeX:self.btnRead.frame withOffX:-5], [self relativeY:self.btnCode.frame withOffY:10], 150, 20);
    
    [self.btnAgreement setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.btnAgreement setTitle:@"《在那儿服务协议》" forState:UIControlStateNormal];
    
    self.btnAgreement.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    self.btnAgreement.backgroundColor = [UIColor clearColor];
    
    [self.btnAgreement addTarget:self action:@selector(openDeal) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnAgreement];
    
    
    self.btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnNext.frame = CGRectMake(10, [self relativeY:self.btnAgreement.frame withOffY:30], frame.size.width - 20, 45);
    
    [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    
    self.btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.btnNext.backgroundColor = [self retRGBColorWithRed:57 andGreen:158 andBlue:239];
    
    self.btnNext.layer.cornerRadius = 5.0f;
    
    self.btnNext.layer.masksToBounds = YES;
    
    [self.btnNext addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnNext];
   
}

-(void)doAgree:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self.btnNext setEnabled:YES];
        [self.btnNext setAlpha:1.0f];
    }
    else{
        [self.btnNext setEnabled:NO];
        [self.btnNext setAlpha:0.6f];
    }
    
}

-(void)openDeal{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:USER_DEAL]];

}

@end
