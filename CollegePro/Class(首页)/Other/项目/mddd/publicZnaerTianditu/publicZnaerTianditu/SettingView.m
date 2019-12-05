//
//  SettingView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/23.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "SettingView.h"
#import "LoginViewController.h"
#import "UserManagerHandler.h"
//#import "OffLineMapViewController.h"
//#import "XGPush.h"
#import "Constants.h"
#define rows 3

#define rowHeight 55.0f

@implementation SettingView

-(void)layoutView:(CGRect)frame{
    
    self.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.NavigateBarHeight, frame.size.width, rows * rowHeight)];

    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
    
    self.exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitBtn.frame = CGRectMake(10, rows * rowHeight + 80, frame.size.width - 20, 45);
    [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.exitBtn.backgroundColor = [self retRGBColorWithRed:255 andGreen:106 andBlue:118];
    [self.exitBtn addTarget:self action:@selector(logoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.exitBtn];
    
}

-(void)logoutBtnAction:(UIButton *)button{
   
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.controller presentViewController:loginVC animated:YES completion:^{
        UserManagerHandler *handler = [[UserManagerHandler alloc]init];
        [handler doLoginOut];//清空所有数据
        //注销别名推送
//        [XGPush setAccount:@"*"];
       
    }];
    
    [self.controller hideTabBar];
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon1_map.png"];
            cell.textLabel.text = @"离线地图";
            
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon2_yinshen.png"];
            cell.textLabel.text = @"隐身模式设置";
            
            cell.accessoryView = [[UISwitch alloc]init];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon3_about_us.png"];
            cell.textLabel.text = @"关于在那儿";
            break;
            
        default:
            break;
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, self.frame.size.width, 1)];
    lineView.backgroundColor = [self retRGBColorWithRed:235 andGreen:235 andBlue:235];
    
    [cell.contentView addSubview:lineView];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row == 0) {
        [self.controller.navigationController pushViewController:[[OffLineMapViewController alloc]init] animated:YES];
    }
  
}

@end
