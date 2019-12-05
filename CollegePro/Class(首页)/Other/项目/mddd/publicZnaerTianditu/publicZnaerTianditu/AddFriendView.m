//
//  AddFriendView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/19.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "AddFriendView.h"
#import "WXHLGlobalUICommon.h"
#import "AddressBookViewController.h"
//#import "ScanViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
@implementation AddFriendView


-(void)layoutView:(CGRect)frame
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    UIView *viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, 80)];
#else
    UIView *viewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.frame.size.width, 80)];
#endif
    
    viewbg.backgroundColor = [UIColor whiteColor];
    
    UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bt_01.png"]];
    searchIcon.frame = CGRectMake(20, 22, 25, 25);
    
    [viewbg addSubview:searchIcon];
    
    self.accountTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 20, viewbg.frame.size.width - 70, 30)];
    
    self.accountTF.font = [UIFont systemFontOfSize:16.0f];
    self.accountTF.textColor = [UIColor blackColor];
    self.accountTF.placeholder = @"手机号/在那儿ID";
    self.backgroundColor = [UIColor clearColor];
    self.accountTF.returnKeyType = UIReturnKeySearch;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 50, viewbg.frame.size.width - 40, 2)];
    line.backgroundColor = RGB(230, 230, 230);
    
    [viewbg addSubview:self.accountTF];
    
    [viewbg addSubview:line];
    
    [self addSubview:viewbg];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    UIView *viewbg2 = [[UIView alloc]initWithFrame:CGRectMake(10, 134, self.frame.size.width - 20, 100)];
#else
    UIView *viewbg2 = [[UIView alloc]initWithFrame:CGRectMake(10, 154, self.frame.size.width - 20, 100)];
#endif
    
    viewbg2.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 50, viewbg2.frame.size.width - 20, 2)];
    lineView.backgroundColor = RGB(230, 230, 230);
    [viewbg2 addSubview:lineView];
    
    UIButton *contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, viewbg2.frame.size.width - 20, 30)];
    [contactBtn setImage:[UIImage imageNamed:@"lianxiren.png"] forState:UIControlStateNormal];
    contactBtn.tag = 100;
    [contactBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [contactBtn setTitle:@"添加手机联系人" forState:UIControlStateNormal];
    [contactBtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    contactBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    contactBtn.titleEdgeInsets = UIEdgeInsetsMake(0,  -contactBtn.frame.size.width/2 + 50, 0, 0);
    contactBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -contactBtn.frame.size.width/2 + 10, 0, 0);
    
    UIButton *smBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, viewbg2.frame.size.width - 20, 30)];
    [smBtn setImage:[UIImage imageNamed:@"saoyisao.png"] forState:UIControlStateNormal];
    smBtn.tag = 200;
    [smBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [smBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    [smBtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    smBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    smBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -smBtn.frame.size.width/2, 0, 0);
    smBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -smBtn.frame.size.width/2 - 50, 0, 0);
    
    [viewbg2 addSubview:contactBtn];
    [viewbg2 addSubview:smBtn];
    
    [self addSubview:viewbg2];
}

-(void)btnAction:(UIButton *)btn{
    if (btn.tag == 100) {
        //添加手机联系人
        [self.controller.navigationController pushViewController:[[AddressBookViewController alloc]init] animated:YES];
    }
    else if (btn.tag == 200){
        //扫一扫
//        [self.controller.navigationController pushViewController:[[ScanViewController alloc]init] animated:YES];
    }
}

@end
