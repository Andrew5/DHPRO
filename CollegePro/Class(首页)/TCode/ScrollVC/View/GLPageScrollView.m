//
//  GLPageScrollView.m
//  GLPageUIScrollView
//
//  Created by 高磊 on 2017/3/3.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLPageScrollView.h"
#import "UIImageView+DHSDSetURLImage.h"

//scrollView 的最大滚动范围
static NSInteger const kMaxNumber = 3;

//默认自动滚动时间
static CGFloat const kTimer = 2.0;

@interface GLPageScrollView ()<UIScrollViewDelegate>
{
    //记录起始位置
    CGFloat         _startOffsetX;
    //记录将要滑动时的位置
    CGFloat         _willEndOffsetX;
    //记录滑动结束后的位置
    CGFloat         _endOffsetX;
}
//滚动view 用以承载view
@property (nonatomic,strong) UIScrollView *scrollView;
//最左侧
@property (nonatomic,strong) UIImageView *leftImageView;
//居中的
@property (nonatomic,strong) UIImageView *middleImageView;
//最右侧
@property (nonatomic,strong) UIImageView *rightImageView;
//当前显示的位置
@property (nonatomic,assign) NSInteger currentIndex;
//定时器
@property (nonatomic, assign) CFRunLoopTimerRef timer;

@end

@implementation GLPageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)removeFromSuperview
{
    [self pauseTimer];
    
    [super removeFromSuperview];
}

#pragma mark == private method
- (void)initialize
{
    self.currentIndex = 0;
    _startOffsetX = 0;
    _willEndOffsetX = 0;
    _endOffsetX = 0;
    self.timeinterval = kTimer;
    [self addSubview:self.scrollView];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

-(void)loadImage
{
    if (_endOffsetX < _willEndOffsetX && _willEndOffsetX < _startOffsetX)
    {
        //画面从右往左移动，前一页

        _currentIndex = (_currentIndex + _images.count - 1) % _images.count;
    }
    else if (_endOffsetX > _willEndOffsetX && _willEndOffsetX > _startOffsetX)
    {
        //画面从左往右移动，后一页
        
        _currentIndex = (_currentIndex + 1) % _images.count;
    }
    
    //左边的index
    NSInteger leftIndex = (_currentIndex + _images.count - 1) % _images.count;
    //右边的index
    NSInteger rightIndex = (_currentIndex + 1) % _images.count;
    
    [_middleImageView setImageViewContent:_images[_currentIndex]];
    [_rightImageView setImageViewContent:_images[rightIndex]];
    [_leftImageView setImageViewContent: _images[leftIndex]];
}

- (void)startTimer
{
    [self cofigTimer];
}

//停止定时器
- (void)pauseTimer
{
    if (self.timer)
    {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
}

//配置定时器
- (void)cofigTimer
{
    if (self.images.count <= 1)
    {
        return;
    }
    
    if (self.timer)
    {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
    
    __weak typeof(self)weakSelf = self;
    
    CFRunLoopTimerRef time = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent()+ _timeinterval, _timeinterval, 0, 0, ^(CFRunLoopTimerRef timer) {
        [weakSelf autoScroll];
    });
    self.timer  = time;
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), time, kCFRunLoopCommonModes);
}

- (void)autoScroll
{
    //画面从左往右移动，后一页
    _currentIndex = (_currentIndex + 1) % _images.count;
    //左边的index
    NSInteger leftIndex = (_currentIndex + _images.count - 1) % _images.count;
    //右边的index
    NSInteger rightIndex = (_currentIndex + 1) % _images.count;
    

    [UIView animateWithDuration:0.8 animations:^{
        [_scrollView setContentOffset:CGPointMake(2 * _scrollView.bounds.size.width, 0)];
    } completion:^(BOOL finished) {
        [_middleImageView setImageViewContent:_images[_currentIndex]];
        [_rightImageView setImageViewContent:_images[rightIndex]];
        [_leftImageView setImageViewContent: _images[leftIndex]];
        
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
        
        if (self.didScrollToIndexBlock)
        {
            self.didScrollToIndexBlock(_currentIndex);
        }
    }];

}

#pragma mark == setter
- (void)setImages:(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    
    _images = images;
    
    NSAssert(images.count >= 2, @"请至少两张图片再使用此类");
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [_leftImageView setImageViewContent: images[images.count - 1]];
    [_middleImageView setImageViewContent:images[_currentIndex]];
    [_rightImageView setImageViewContent:images[_currentIndex + 1]];
    
    [self startTimer];
}

- (void)setTimeinterval:(NSTimeInterval)timeinterval
{
    _timeinterval = timeinterval;
    
    [self startTimer];
}


#pragma mark == event response
- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.didSelectIndexBlock)
    {
        self.didSelectIndexBlock(_currentIndex);
    }
}


#pragma mark == UIScrollViewDelegate

//即将开始拖拽的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //拖动前的起始坐标
    _startOffsetX = scrollView.contentOffset.x;
    
    [self pauseTimer];
}

//停止拖拽的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

//即将减速的时候
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _willEndOffsetX = scrollView.contentOffset.x;
}

//减速停止的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _endOffsetX = scrollView.contentOffset.x;
    
    //给imageview赋值
    [self loadImage];
    //改变offset  
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    
    if (self.didScrollToIndexBlock)
    {
        self.didScrollToIndexBlock(_currentIndex);
    }
}

#pragma mark == 懒加载
- (UIScrollView *)scrollView
{
    if (nil == _scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        _scrollView.contentSize = CGSizeMake(kMaxNumber * self.bounds.size.width, self.bounds.size.height);
        _scrollView.delegate = (id)self;
        _scrollView.showsVerticalScrollIndicator = _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)leftImageView
{
    if (nil == _leftImageView)
    {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    }
    return _leftImageView;
}

- (UIImageView *)middleImageView
{
    if (nil == _middleImageView)
    {
        _middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView
{
    if (nil == _rightImageView)
    {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    }
    return _rightImageView;
}

@end
