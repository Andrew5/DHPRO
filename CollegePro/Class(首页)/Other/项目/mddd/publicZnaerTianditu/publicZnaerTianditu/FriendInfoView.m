//
//  FriendInfoView.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "FriendInfoView.h"

@implementation FriendInfoView


-(void)layoutView:(CGRect)frame{
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavigateBarHeight, frame.size.width, 200)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    self.headImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    
    self.headImage.layer.cornerRadius = 5.0f;
    
    self.headImage.layer.masksToBounds = YES;
    
    [headView addSubview:self.headImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 80, 20)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:18.0f];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:self.nameLabel];
    
    self.codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 68, 36 ,28, 28)];
    
    [self.codeBtn setImage:[UIImage imageNamed:@"2code.png"] forState:UIControlStateNormal];
    
    [headView addSubview:self.codeBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 100, frame.size.width, 2)];
    [line setBackgroundColor:[self retRGBColorWithRed:235 andGreen:235 andBlue:235]];
    [headView addSubview:line];
    
    
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
    
    self.makeFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.makeFriendBtn.frame = CGRectMake(20, 300, frame.size.width-40, 55);
    self.makeFriendBtn.backgroundColor = [UIColor greenColor];
    [self.makeFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.makeFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
    self.makeFriendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.makeFriendBtn.layer.masksToBounds = YES;
    self.makeFriendBtn.layer.cornerRadius = 8.0f;
    self.makeFriendBtn.layer.borderWidth = 1.0f;
    self.makeFriendBtn.layer.borderColor = [[UIColor whiteColor]CGColor];

    
    [self addSubview:headView];
    [self addSubview:self.makeFriendBtn];
    self.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
    
}





@end
