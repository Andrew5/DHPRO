//
//  DistinationHeadView.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DistinationHeadView.h"

@implementation DistinationHeadView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHead];
    }
    return self;
}

-(void)createHead
{

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 1, [UIScreen mainScreen].bounds.size.width, 27);
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.button.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"zu"]];
    [self addSubview:self.button];
}
-(void)click:(UIButton *)button
{
    [self.delegate sendButton:button];
}
@end
