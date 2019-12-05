//
//  ADView.m
//  09-04UISrollViewRepeate
//
//  Created by 郝海圣 on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ADView.h"

#define  WIDTH self.frame.size.width
#define  HEIGHT self.frame.size.height
@interface ADView()<UIScrollViewDelegate>
{
    NSInteger _currentPage;//记录当前的显示页

}
@property (nonatomic,copy) GoBackBlock goBlock;

@end
@implementation ADView

-(id)initWithArray:(NSArray *)array  andFrame:(CGRect)frame andBlock:(GoBackBlock)back{
    if (self = [super init]) {
        self.frame  = frame;
        NSMutableArray *ra = [NSMutableArray arrayWithArray:array];
        NSString *s0 = array[0];
        NSString *tailS = array[array.count - 1];
        [ra insertObject:tailS atIndex:0 ];
        [ra addObject:s0];
        self.imageArray = [NSArray arrayWithArray:ra];
        [self configUI];
        self.goBlock = back;
        

    }
    return self;
}

-(void)configUI{
    UIScrollView *scr = [[UIScrollView alloc]initWithFrame:self.bounds];
    scr.backgroundColor = [UIColor yellowColor];
    //创建滚动视图的子视图
    NSArray *imageArray = self.imageArray;

    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH,HEIGHT )];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.userInteractionEnabled = YES;
        [scr addSubview:imageView];
        
        if (i == imageArray.count-2) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor clearColor];
            
            [imageView addSubview:btn];
            
        }
    }
    
    //设置内容视图的大小
    scr.contentSize = CGSizeMake(imageArray.count*WIDTH, HEIGHT);
    //用户看到的第一张
    scr.contentOffset = CGPointMake(WIDTH, 0);
    //设置回弹效果
    scr.bounces = NO;
    //设置代理
    scr.delegate = self;
    //翻页效果
    scr.pagingEnabled = YES;
    //设置水平的指示条
    scr.showsHorizontalScrollIndicator = NO;
    [self addSubview:scr];
    
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(250, 250, 100, 50 )];
    page.numberOfPages = imageArray.count -2;
    page.pageIndicatorTintColor  = [UIColor yellowColor];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    _currentPage = 1;
    //设置页码指示器的页码
    page.currentPage = _currentPage-1;
    page.tag = 20;
   //[self addSubview:page];
}
-(void)go{
    self.goBlock();
    
}
#pragma mark 协议方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //图片的位置          1    2    3     4     5
    //图片的坐标          0    300  600   900   1200
    //图片的地址          2    0    1     2     0
    //_currentpage          0    1    2     3     4 记录的是真实的页码
    //页码指示器.currentPage       0    1     2
    //获取偏移量
    CGPoint point = scrollView.contentOffset;
    if (point.x == 0) {
        scrollView.contentOffset = CGPointMake(WIDTH*(self.imageArray.count-2), 0);
        
    }
    if (point.x == WIDTH*(self.imageArray.count-1)) {
        scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }
    //获得页码指示器
    UIPageControl *page = (UIPageControl *)[self viewWithTag:20];
    _currentPage = scrollView.contentOffset.x/WIDTH;
    page.currentPage = _currentPage-1;
}


@end
