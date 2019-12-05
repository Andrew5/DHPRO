//
//  AlertInfoItemViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/21.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "AlertInfoItemViewController.h"
#import "UserEntity.h"
#import "UserManagerHandler.h"
#import "SVProgressHUD.h"
#import "UserInfoStorage.h"
@interface AlertInfoItemViewController ()
{
    NSDictionary *_vaule;
    UserEntity *_userEntity;
    UserManagerHandler *_handler;
    int code;
}
@end

@implementation AlertInfoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.0f];
    
    UIView *tfView = [[UIView alloc]initWithFrame:CGRectMake(15, 80, self.view.frame.size.width - 30, 40)];
    tfView.backgroundColor = [UIColor whiteColor];
    tfView.layer.masksToBounds = YES;
    tfView.layer.cornerRadius = 8.0f;
    tfView.layer.borderColor = [[UIColor grayColor]CGColor];
    tfView.layer.borderWidth = 1.0f;
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, tfView.frame.size.width - 10, 40)];
    
    self.tf.font = [UIFont systemFontOfSize:16.0f];
    self.tf.textColor = [UIColor blackColor];
    self.tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [tfView addSubview:self.tf];
    
    [self.view addSubview:tfView];
    
    _userEntity = [_vaule objectForKey:@"user"];
    code = [[_vaule objectForKey:@"code"]intValue];
    
    if (code == ALERT_NICKNAME) {
        self.title = @"昵称";
        self.tf.text = _userEntity.nickName;
        
    }
    else if (code == ALERT_PS){
        self.title = @"备注";
        self.tf.placeholder = @"备注";
        self.tf.text = _userEntity.remark;
    }
    
    [self addNaviRightBtn];
    
    __unsafe_unretained AlertInfoItemViewController *safeSelf = self;
    _handler = [[UserManagerHandler alloc]init];
    _handler.successBlock = ^(id obj){
        //本地保存用户信息
        UserInfoStorage *storage = [UserInfoStorage defaultStorage];
        [storage saveUserInfo:safeSelf -> _userEntity];
        [safeSelf.navigationController popViewControllerAnimated:YES];
    };
}

-(void)addNaviRightBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItems:@[rightItem] animated:YES];
}

-(void)doSave{
    
    [self.tf resignFirstResponder];
    NSString *str = self.tf.text;
    if (str.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入任何内容"];
        return;
    }
    
    NSDictionary *params;
    if (code == ALERT_NICKNAME) {
        if ([str isEqualToString:_userEntity.nickName]) {
            return;
        }
        
        params = @{@"equipId":_userEntity.equipID,@"equipName":str};
        _userEntity.nickName = str;
        
    }
    else if (code == ALERT_PS){
        if ([str isEqualToString:_userEntity.remark]) {
            return;
        }
        
         params = @{@"equipId":_userEntity.equipID,@"remark":str};
        _userEntity.remark = str;
    }
    
    
    //保存数据
    [_handler alertUserInfo:params];
    
}

#pragma mark - PassValueDelegate
- (void)setValue:(NSObject *)value{
    _vaule = (NSDictionary *)value;
}



@end
