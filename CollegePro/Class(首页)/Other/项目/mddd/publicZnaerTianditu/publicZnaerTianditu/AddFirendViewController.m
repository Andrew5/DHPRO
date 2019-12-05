//
//  AddFirendViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/19.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "AddFirendViewController.h"
#import "FriendManagerHandler.h"
#import "SVProgressHUD.h"
#import "SearchFriendsResultTableViewViewController.h"


@interface AddFirendViewController ()
{
    FriendManagerHandler *_handler;
    NSArray *_data;
}
@end

@implementation AddFirendViewController

-(void)loadView{
    [super loadView];
    self.addFirendView = [[AddFriendView alloc]initWithController:self];
    
    self.addFirendView.backgroundColor = RGB(232, 232, 232);
    
    self.addFirendView.accountTF.delegate = self;
    
    [self.view addSubview:self.addFirendView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加好友";
    
    _handler = [[FriendManagerHandler alloc]init];
    
    __unsafe_unretained AddFirendViewController *safeSelf = self;
    
    _handler.successBlock = ^(id obj){
      
        safeSelf -> _data = obj;
        
        SearchFriendsResultTableViewViewController *resultVC = [[SearchFriendsResultTableViewViewController alloc]init];
        
        safeSelf.valueDelegate = resultVC;
        
        [safeSelf.valueDelegate setValue:safeSelf -> _data];
        
        [safeSelf.navigationController pushViewController:resultVC animated:YES];
        
        
        
    };
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
   
    NSString *num = textField.text;
    
    if (num.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索号码"];
        return NO;
    }
   
    [_handler searchFriendWithNum:num];
    
    return YES;
}

@end
