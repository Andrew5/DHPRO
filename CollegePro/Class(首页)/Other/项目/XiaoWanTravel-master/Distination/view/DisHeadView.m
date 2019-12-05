//
//  DisHeadView.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/25.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DisHeadView.h"

@implementation DisHeadView
{
    NSTimer* _timer;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
        [self creatadView];
    }
    return self;
}
-(void)creatadView
{
    //创建广告栏
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 252, 10, 25)];
    self.imageV.image = [UIImage imageNamed:@"bg_profile_passport_blue@2x"];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 252, [UIScreen mainScreen].bounds.size.width-15, 25)];
    self.titleLabel.font=[UIFont systemFontOfSize:18];
    self.titleLabel.textColor=[UIColor blackColor];
    //self.titleLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"zu"]];
    self.titleLabel.text = @"热门城市";
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageV];

    
    
        //创建计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:YES];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer invalidate];
}

//结束减速，滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index=_scrollView.contentOffset.x/self.frame.size.width;
    if (index==_array.count) {
        index=0;
        _scrollView.contentOffset=CGPointZero;
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:YES];
}

-(void)time{
    _scrollView.contentOffset=CGPointMake(_scrollView.contentOffset.x+self.frame.size.width, 0);
    NSInteger index=_scrollView.contentOffset.x/self.frame.size.width;
    if (index==_array.count) {
        index=0;
        _scrollView.contentOffset=CGPointZero;
    }

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = _scrollView.contentOffset.y;
    
    if (offsetY < 0)
    {
        CGFloat scale = 1 - offsetY/100;
        _scrollView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

@end
