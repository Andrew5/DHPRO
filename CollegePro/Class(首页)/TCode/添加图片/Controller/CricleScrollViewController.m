//
//  CricleScrollViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/2.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CricleScrollViewController.h"

@interface CricleScrollViewController ()<UIScrollViewDelegate>{
    UIScrollView *_cricleScrollerview;
    UIPageControl *pageControl;
    NSTimer *timer;//轮播定时器
    
    NSArray *_imageViewsDatasrc;//循环的图片集合
    NSMutableArray *_curImageViews;//当前显示载入的图片集合  3张
    NSInteger _curIndex;//当前指示的图片指针
    NSArray *deepCopyArray;
}

@end

@implementation CricleScrollViewController
@synthesize cricleScrollerview=_cricleScrollerview;
@synthesize imageViewsDatasrc=_imageViewsDatasrc;
@synthesize delegate;
- (id) initWithFrame:(CGRect)frame  andImagesArray:(NSArray *)imagesArray{
    self = [super init];
    if(self){
        self.imageViewsDatasrc = imagesArray;
        [self.view setFrame:frame];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     *  初始化Scrollerview
     */
    _cricleScrollerview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if(_imageViewsDatasrc.count>=2){//图片大于2张才进行轮播
        //init
        _curImageViews = [[NSMutableArray alloc] initWithCapacity:10];
        _curIndex = 0;
        
        if(_imageViewsDatasrc.count==2){
            deepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:_imageViewsDatasrc]];
        }
        
        [_cricleScrollerview setContentSize:CGSizeMake(3*_cricleScrollerview.bounds.size.width, _cricleScrollerview.bounds.size.height)];
        
        for(int i=0; i<3; i++){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*_cricleScrollerview.bounds.size.width, 0.0, _cricleScrollerview.bounds.size.width, _cricleScrollerview.bounds.size.height)];
            [view setTag:100+i];
            [_cricleScrollerview addSubview:view];
        }
        
    }
    else{//小于2张不轮播
        [_cricleScrollerview setContentSize:CGSizeMake(_imageViewsDatasrc.count*_cricleScrollerview.bounds.size.width, _cricleScrollerview.bounds.size.height)];
        
        for(int i=0; i<_imageViewsDatasrc.count; i++){
            UIView *view = [_imageViewsDatasrc objectAtIndex:i];
            [view setFrame:CGRectMake(i*_cricleScrollerview.bounds.size.width, 0.0, _cricleScrollerview.bounds.size.width, _cricleScrollerview.bounds.size.height)];
            [_cricleScrollerview addSubview:view];
        }
    }
    
    [_cricleScrollerview setDelegate:self];
    [_cricleScrollerview setPagingEnabled:YES];
    [_cricleScrollerview setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_cricleScrollerview];
    
    /**
     *   初始化翻页指示器、定时器
     */
    //大于一张图片则展示翻页指示器
    if(_imageViewsDatasrc.count>1){
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2,170, 150, 30)];
        pageControl.hidden = YES;
        [pageControl setNumberOfPages:_imageViewsDatasrc.count];
        [self.view addSubview:pageControl];
        
        //大于一张图片则初始化广告图轮播定时器
        if(nil!=timer){
            [timer invalidate];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timeUpdateToCricleScrollerView) userInfo:nil repeats:YES];
    }
    
    //刷新ScrollerView
    if(_imageViewsDatasrc.count>=2) [self refreshScrollerView];
    
}

/**
 *  定时器翻页
 */
- (void)timeUpdateToCricleScrollerView{
    if(_imageViewsDatasrc.count>=2){//广告图轮播处理 定时往下翻一页
        [_cricleScrollerview setContentOffset:CGPointMake(_cricleScrollerview.bounds.size.width+_cricleScrollerview.bounds.size.width, 0.0) animated:YES];
    }
    
}

/**
 *  每次拖拽ScrollerView切换图片的时候调用
 *  在scrollViewDidScroll中调用,循环切换图片
 */
- (void)refreshScrollerView{
    UIView *view0 = [_cricleScrollerview viewWithTag:100];
    UIView *view = [_cricleScrollerview viewWithTag:101];
    UIView *view1 = [_cricleScrollerview viewWithTag:102];
    
    for (UIView *views in view0.subviews) {
        [views removeFromSuperview];
    }
    for (UIView *views in view.subviews) {
        [views removeFromSuperview];
    }
    for (UIView *views in view1.subviews) {
        [views removeFromSuperview];
    }
    
    _curImageViews = [self configCurImageViewsArray];
    
    UIView *tmpView0 = [_curImageViews objectAtIndex:0];
    UIView *tmpView = [_curImageViews objectAtIndex:1];
    UIView *tmpView1 = [_curImageViews objectAtIndex:2];
    
    [view0 addSubview:tmpView0];
    [view addSubview:tmpView];
    [view1 addSubview:tmpView1];
    
    //每次切换图片后都将ScrollerView的ContentOffset设置为显示在中间的图片上
    [_cricleScrollerview setContentOffset:CGPointMake(_cricleScrollerview.bounds.size.width, 0.0)];
}

//初始化当前显示载入的图片集合  3张
- (NSMutableArray *)configCurImageViewsArray{
    
    [_curImageViews removeAllObjects];
    
    UIView *tmpView0 = [_imageViewsDatasrc objectAtIndex:[self getIndexForCurImages:_curIndex-1]];
    UIView *tmpView = [_imageViewsDatasrc objectAtIndex:[self getIndexForCurImages:_curIndex]];
    UIView *tmpView1;
    if(_imageViewsDatasrc.count==2){
        tmpView1 = [deepCopyArray objectAtIndex:[self getIndexForCurImages:_curIndex+1]];
    }else{
        tmpView1 = [_imageViewsDatasrc objectAtIndex:[self getIndexForCurImages:_curIndex+1]];
    }
    
    [_curImageViews addObject:tmpView0];
    [_curImageViews addObject:tmpView];
    [_curImageViews addObject:tmpView1];
    
    return _curImageViews;
}

//获得当前载入显示的图片数组（_curImageViews）的图片下标位置
- (NSInteger)getIndexForCurImages:(NSInteger)index{
    if(index>=0 && index<_imageViewsDatasrc.count){
        return index;
    }
    else if (index<0){
        index = _imageViewsDatasrc.count + index;
        return index;
    }
    else if (index>=_imageViewsDatasrc.count){
        index = index - _imageViewsDatasrc.count;
        return index;
    }
    return 0;
}


#pragma mark -- UIScrollerview Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片小于2张不轮播处理
    if(_imageViewsDatasrc.count<2) return;
    
    
    //图片大于等于2张轮播处理
    int x=scrollView.contentOffset.x;
    
    if(x>=2*scrollView.bounds.size.width){ //往下翻一张
        
        _curIndex=[self getIndexForCurImages:_curIndex+1];
        //[delegate cricleScrollViewDidScrollToIndex:_curIndex];
        [pageControl setCurrentPage:_curIndex];
        
        //刷新ScrollerView视图
        [self refreshScrollerView];
        
    }
    
    
    if(x<=0){//往上翻一张
        
        _curIndex=[self getIndexForCurImages:_curIndex-1];
        //[delegate cricleScrollViewDidScrollToIndex:_curIndex];
        [pageControl setCurrentPage:_curIndex];
        
        //刷新ScrollerView视图
        [self refreshScrollerView];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.view window] == nil)
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        [self viewDidUnloadForMemoryWarning];
        self.view = nil;
    }
    
}
- (void)viewDidUnloadForMemoryWarning {
    if(_curImageViews){
        _curImageViews = nil;
    }
    if(deepCopyArray){
        deepCopyArray = nil;
    }
}

-(void)dealloc{
    if(_curImageViews){
        _curImageViews = nil;
    }
    if(deepCopyArray){
        deepCopyArray = nil;
    }
    NSLog(@"滚动图页面释放了");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
