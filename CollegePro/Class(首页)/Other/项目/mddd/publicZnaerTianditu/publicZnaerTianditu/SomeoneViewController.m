//
//  SomeoneViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "SomeoneViewController.h"
#import "UserInfoStorage.h"
#import "UserEntity.h"
#import "UIImageView+AFNetworking.h"
#import "MeInfoViewController.h"
#import "BaseHandler.h"
@implementation SomeoneViewController
{
    UserInfoStorage *_userInfoStorage;
    UserEntity *_userEntity;
}
@synthesize someoneView;

-(void)loadView{
    [super loadView];
    
    self.someoneView = [[SomeoneView alloc]initWithController:self];
    
    [self.view addSubview:self.someoneView];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitle:@"我"];
    
    [self hideLeftBackBtn];
    
    [self.someoneView.infoBtn addTarget:self action:@selector(infoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _userInfoStorage = [UserInfoStorage defaultStorage];
    _userEntity = [_userInfoStorage getUserInfo];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTabBar];
    
    NSString *placeHolderHead = (_userEntity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
    self.someoneView.nameLabel.text = _userEntity.nickName;
    self.someoneView.psLabel.text = _userEntity.remark;
    NSString *imageUrl = [BaseHandler retImageUrl:_userEntity.equipIcon];
    NSURL *url = [NSURL URLWithString:imageUrl];
    [self.someoneView.headImage setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
}

-(void)infoBtnAction:(UIButton *)btn{
    MeInfoViewController *meInfoVC = [[MeInfoViewController alloc]init];
    self.valueDelegate = meInfoVC;
    [self.valueDelegate setValue:_userEntity];
    [self.navigationController pushViewController:meInfoVC animated:YES];
    [self hideTabBar];
}
@end
