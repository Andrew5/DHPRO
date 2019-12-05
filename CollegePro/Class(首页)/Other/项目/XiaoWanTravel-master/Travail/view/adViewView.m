//
//  adViewView.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "adViewView.h"

@implementation adViewView
{
    NSTimer* _timer;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
        [self creatadView];
    }
    return self;
}
-(void)creatadView
{
    //创建广告栏
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    //创建小白点
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-120)/2, 160, 120, 30)];
    _page.alpha = 0.8;
    _page.userInteractionEnabled = NO;
    _page.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:0.83 blue:0.39 alpha:1];
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_page];
    
    //创建广告栏下方的按钮
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 96)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"PayOnlineBackgroudImg"];
    [self addSubview:imageV];
    NSArray *array = @[@"看锦囊",@"抢折扣"];
    NSArray *imageArray = @[@"btn_poi_ent_on@3x",@"btn_poi_shopping_on@3x"];
    CGFloat h = ([UIScreen mainScreen].bounds.size.width-120)/3;
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(h+(60+h)*i, 10, 60, 60);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAd:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 500+i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(h+(65+h)*i, 65, 60, 40)];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        [imageV addSubview:button];
        [imageV addSubview:label];
    }
    //创建计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:YES];
}

-(void)clickAd:(UIButton*)button
{
    [self.delegate sendadButton:button];
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
    _page.currentPage=index;
    _timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(time) userInfo:nil repeats:YES];
}

-(void)time{
    _scrollView.contentOffset=CGPointMake(_scrollView.contentOffset.x+self.frame.size.width, 0);
    NSInteger index=_scrollView.contentOffset.x/self.frame.size.width;
    if (index==_array.count) {
        index=0;
        _scrollView.contentOffset=CGPointZero;
    }
    _page.currentPage=index;
}

@end
