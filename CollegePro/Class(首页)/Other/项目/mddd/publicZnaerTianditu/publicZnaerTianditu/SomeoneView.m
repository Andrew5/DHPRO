//
//  SomeoneView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "SomeoneView.h"
#import "SettingViewController.h"
@implementation SomeoneView

-(void)layoutView:(CGRect)frame{
    
  
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavigateBarHeight, frame.size.width, 200)];

    headView.backgroundColor = [UIColor whiteColor];
    
    self.headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"demo.png"]];
    
    self.headImage.frame = CGRectMake(20, 20, 50, 50);
    
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 5.0f;
    
    [headView addSubview:self.headImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 100, 20)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:self.nameLabel];
    
    self.codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 90, 36 ,28, 28)];
    
    [self.codeBtn setImage:[UIImage imageNamed:@"2code.png"] forState:UIControlStateNormal];
    
    [headView addSubview:self.codeBtn];
    
    UIImageView *arrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next_icon.png"]];
    arrowIV.frame = CGRectMake(frame.size.width - 40, 38, 24, 24);
    [headView addSubview:arrowIV];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, frame.size.width, 1)];
    [line setBackgroundColor:[self retRGBColorWithRed:235 andGreen:235 andBlue:235]];
    [headView addSubview:line];
    
    self.infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoBtn.frame = CGRectMake(0, 0, frame.size.width, 100);
    self.infoBtn.backgroundColor =[UIColor clearColor];
    
    [headView addSubview:self.infoBtn];
    
    UILabel *psTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 135, 40, 30)];
    psTitleLabel.textColor = [self retRGBColorWithRed:182 andGreen:182 andBlue:182];
    psTitleLabel.font = [UIFont systemFontOfSize:20.0f];
    psTitleLabel.text = @"备注";
    
    [headView addSubview:psTitleLabel];
    
    self.psLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 130, frame.size.width - 120, 40)];
    self.psLabel.textColor = [UIColor blackColor];
    self.psLabel.font = [UIFont systemFontOfSize:16.0f];
    self.psLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.psLabel.numberOfLines = 2;
    
    [headView addSubview:self.psLabel];
    
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setBtn.frame = CGRectMake(0, [self relativeY:headView.frame withOffY:20], frame.size.width, 55);
    self.setBtn.backgroundColor = [UIColor whiteColor];
    [self.setBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.setBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [self.setBtn setImage:[UIImage imageNamed:@"set_bt1.png"] forState:UIControlStateNormal];
    [self.setBtn setImage:[UIImage imageNamed:@"set_bt1.png"] forState:UIControlStateHighlighted];
    
    self.setBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -frame.size.width/3 * 2, 0, 0);
    self.setBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0);
    
    [self.setBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:headView];
    [self addSubview:self.setBtn];
    self.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
    
}

-(void)setBtnAction{
    
    [self.controller.navigationController pushViewController:[[SettingViewController alloc]init] animated:YES];
    [self.controller hideTabBar];
}



@end
