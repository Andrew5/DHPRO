//
//  UserBindViewController.h
//  btc
//
//  Created by txj on 15/3/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBaseUIViewController.h"
#import "UserBackend.h"

@class UserBindViewController;
@protocol UserBindViewControllerDelegate <NSObject>

-(void)finishBindUser:(USER *)anUser bindController:(UserBindViewController *)controller;

@end

@interface UserBindViewController : TBaseUIViewController
@property (strong, nonatomic) id<UserBindViewControllerDelegate> delegate;
@property (strong, nonatomic) UserBackend *backend;

@property (weak, nonatomic) IBOutlet UITextField *tvusername;
@property (weak, nonatomic) IBOutlet UITextField *tvpassword;

@property (weak, nonatomic) IBOutlet UILabel *lbtitle;

@property (weak, nonatomic) IBOutlet UIView *vsplit;
@property (weak, nonatomic) IBOutlet UIView *vuserinfo;
@property (weak, nonatomic) IBOutlet UILabel *lbusername;
@property (weak, nonatomic) IBOutlet UILabel *lbpassword;


@property (weak, nonatomic) IBOutlet UIButton *haveAccount;
@property (weak, nonatomic) IBOutlet UIButton *registerNewAccount;
- (IBAction)haveAccountTapped:(id)sender;
- (IBAction)registerAccountTapped:(id)sender;
@property (strong, nonatomic) USER *user;
-(instancetype)initWithUserMode:(USER *)user;


@end
