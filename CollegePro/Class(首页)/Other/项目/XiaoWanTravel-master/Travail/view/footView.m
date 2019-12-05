//
//  footView.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "footView.h"

@implementation footView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self creatFootView];
    }
    return self;
}
-(void)creatFootView
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width, 26);
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"zu"]];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.button];
}
-(void)click:(UIButton *)button
{
    [self.delegate sendButton:button];
}

@end
