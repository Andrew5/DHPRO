//
//  UserSettingViewController.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
#import "FeedbackViewController.h"
/**
 *  其他设置
 */
@interface UserSettingViewController:TBaseUIViewController
<UITableViewDelegate, UITableViewDataSource,FeedbackViewControllerDelegate>
{
    UserBackend *backend;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) USER *user;

@property (strong, nonatomic) UISwitch *switchWl;//物流推送
@property (strong, nonatomic) UISwitch *switchCx;
@property (strong, nonatomic) UISwitch *switchXt;

@property (weak, nonatomic) IBOutlet UIButton *btnLoginOut;
- (IBAction)btnLoginOutTapped:(id)sender;
@end
