//
//  adviseHead.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "adviseHead.h"
#import "PrefixHeader.pch"
@implementation adviseHead

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self creatSubviews];
        self.frame=CGRectMake(0, 0, Screen_Width, 250);
    }
    return self;
}

-(void)creatSubviews{
  
    self.imageHeader=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,Screen_Width, 250)];
    self.imageHeader.userInteractionEnabled=YES;
    [self addSubview:self.imageHeader];
    self.labelhead = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 100, 20)];
    [self addSubview:self.labelhead];
    
    self.downlondBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.downlondBtn.frame=CGRectMake(self.frame.size.width-80, self.frame.size.height-80, 80, 80);
    [self.downlondBtn setTitle:@"下载" forState:UIControlStateNormal];
    [self.downlondBtn setImage:[UIImage imageNamed:@"icon_trip_download@3x"] forState:UIControlStateNormal];
    [self.downlondBtn setImage:[UIImage imageNamed:@"icon_trip_download_pause@3x"] forState:UIControlStateSelected];
    self.downlondBtn.selected = NO;
    
    self.downlondBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    //[self.downlondBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.downlondBtn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[self.downlondBtn setBackgroundColor:[UIColor greenColor]];
    //self.downlondBtn.layer.borderWidth=1;
    //self.downlondBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //self.downlondBtn.layer.cornerRadius=50/2.f;
    [self.imageHeader addSubview:self.downlondBtn];
    
    
    self.progress=[[UIProgressView alloc]initWithFrame:CGRectMake(self.frame.size.width-100, self.frame.size.height+5, 90, 50)];
    //设置当前进度
    self.progress.progress = 0;
    //设置填充
    self.progress.tintColor = [UIColor blueColor];
    self.progress.hidden=YES;
    [self.imageHeader addSubview:self.progress];
    
}

-(void)pressBtn:(UIButton *)btn
{
    [self.delegate downloandSleeve:btn];
    
}


@end
