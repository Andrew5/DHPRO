//
//  ZSDSetPasswordView.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDSetPasswordView;

@protocol ZSDSetPasswordViewDelegate <NSObject>

- (void)passwordView:(ZSDSetPasswordView*)passwordView inputPassword:(NSString*)password;

@end

@interface ZSDSetPasswordView : UIView

@property (nonatomic, weak) id<ZSDSetPasswordViewDelegate> delegate;

@property (nonatomic, strong) UITextField *passwordTextField;

-(void)fieldBecomeFirstResponder;
-(void)clearUpPassword;

@end
