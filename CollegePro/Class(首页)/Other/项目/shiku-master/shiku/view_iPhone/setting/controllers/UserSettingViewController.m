//
//  UserSettingViewController.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserRegisterStep2ViewController.h"


@interface UserSettingViewController ()

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    App *app = [App shared];
    @weakify(self)
    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
        @strongify(self);
        self.user = user;
        [self.switchCx setOn:[self.user.msg_sales boolValue]];
        [self.switchWl setOn:[self.user.msg_express boolValue]];
        [self.switchXt setOn:[self.user.msg_sys boolValue]];
    }];
    self.user=[app currentUser];
    
    self.title=@"其他设置";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.view.backgroundColor=WHITE_COLOR;
    self.user=[[App shared] currentUser];
     backend=[UserBackend shared];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0.0, 0.0);
    
//    self.btnLoginOut.backgroundColor=[UIColor redColor];//MAIN_COLOR;
    self.btnLoginOut.layer.cornerRadius=5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *_cell=[[UITableViewCell alloc] init];
    if (indexPath.section==0) {
        //        AddressEditTableViewCell *cell;
        //        Address *address;
        //        cell = [tableView
        //                dequeueReusableCellWithIdentifier:AddressListTableCell];
        
        if (indexPath.row==0) {
            UILabel *lb=[UILabel new];
            lb.text=@"物流通知";
            [_cell addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.left.equalTo(_cell).offset(12);
            }];
            
            self.switchWl=[UISwitch new];
            [_cell addSubview:self.switchWl];
            [self.switchWl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.right.equalTo(_cell).offset(-10);
            }];
            [self.switchWl setOn:[self.user.msg_express boolValue]];
            self.switchWl.tag=1;
            [self.switchWl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if(indexPath.row==1)
        {
            UILabel *lb=[UILabel new];
            lb.text=@"促销优惠";
            [_cell addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.left.equalTo(_cell).offset(12);
            }];
            
            self.switchCx=[UISwitch new];
            [_cell addSubview:self.switchCx];
            [self.switchCx mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.right.equalTo(_cell).offset(-10);
            }];
            [self.switchCx setOn:[self.user.msg_sales boolValue]];
            self.switchCx.tag=2;
            [self.switchCx addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        else if(indexPath.row==2)
        {
            UILabel *lb=[UILabel new];
            lb.text=@"系统通知";
            [_cell addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.left.equalTo(_cell).offset(12);
            }];
            
            self.switchXt=[UISwitch new];
            [_cell addSubview:self.switchXt];
            [self.switchXt mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.right.equalTo(_cell).offset(-10);
            }];
            [self.switchXt setOn:[self.user.msg_sys boolValue]];
            self.switchXt.tag=3;
            [self.switchXt addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        }
        else if(indexPath.row==3)
        {
            UILabel *lb=[UILabel new];
            lb.text=@"意见反馈";
            [_cell addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.left.equalTo(_cell).offset(12);
            }];
            _cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row==4)
        {
            UILabel *lb=[UILabel new];
            lb.text=@"修改密码";
            [_cell addSubview:lb];
            [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_cell);
                make.left.equalTo(_cell).offset(12);
            }];
            _cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        //_cell=cell;
    }
    else
    {
        //        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 2, _cell.frame.size.width, _cell.frame.size.height)];
        //        btn.backgroundColor=[UIColor redColor];
        //        btn.layer.cornerRadius=5;
        //        [btn setTitle:@"删除地址" forState:UIControlStateNormal];
        //        [_cell addSubview:btn];
        //        _cell.backgroundColor=[UIColor clearColor];
        //        _cell.layer.borderWidth=0;
        //        _cell.layer.borderColor=[UIColor clearColor].CGColor;
        //        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
        //        textLabel.layer.backgroundColor=MAIN_COLOR.CGColor;
        //        textLabel.text=@"删除地址";
        //        textLabel.textColor=[UIColor whiteColor];
        //        textLabel.textAlignment=NSTextAlignmentLeft;
        //        textLabel.layer.cornerRadius=5;
        //        textLabel.layer.borderWidth  = 1.0f;
        //        textLabel.layer.borderColor  = MAIN_COLOR.CGColor;
        //        textLabel.layer.cornerRadius = 5.0f;
        //        [_cell addSubview:textLabel];
        
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return _cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==3)
    {
        FeedbackViewController *v=[FeedbackViewController alloc];
        v.delegate=self;
        [self showNavigationView:v];
    }
    else if(indexPath.row==4)
    {
        UserRegisterStep2ViewController *c=[[UserRegisterStep2ViewController alloc] initModefiyPsw:YES];
        [self.navigationController pushViewController:c animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    CheckoutTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    //    view.shop_item=[self.cart.checkout_shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    //    headerView.delegate=self;
    //    [view bind];
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    CheckoutTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
    //    view.shop_item=[self.cart.shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    [view bind];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(void)switchChanged:(UISwitch *)swith
{
    if ([swith isOn]){
        [[backend requestUpdateUserSetting:swith.tag withValue:@"1"]
         subscribeNext:[self didGetUserInfoSuccess]];
//        NSLog(@"The switch is on.%ld",swith.tag);
    } else {
        [[backend requestUpdateUserSetting:swith.tag withValue:@"0"]
         subscribeNext:[self didGetUserInfoSuccess]];
//        NSLog(@"The switch is off.%ld",swith.tag);
    }
}
- (void(^)(USER *))didGetUserInfoSuccess
{
    return ^(USER *user) {
        if (user==nil) {
            [self.view showHUD:@"操作失败" afterDelay:2];
        }else{
//             [self.view showHUD:@"操作成功" afterDelay:2];
            user.token=self.user.token;
            [[App shared] setCurrentUser:user];
            [backend.repository storage:user];
        }
    };
}

-(void)didSubmitFeedback:(FeedbackViewController *)controller
{
    [self.view showHUD:@"反馈成功，我们会尽快处理" afterDelay:2];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnLoginOutTapped:(id)sender {
    [[UserBackend shared] clearStore];
    [[App shared] setCurrentUser:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"attentionList"];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"Exit" object:self userInfo:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
  

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
