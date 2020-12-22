//
//  DHScrollerTView.m
//  CollegePro
//
//  Created by jabraknight on 2020/11/29.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHScrollerTView.h"
@interface DHScrollerTView()<UIScrollViewDelegate>{
    //记录起始位置
    CGFloat         _startOffsetX;
    //记录将要滑动时的位置
    CGFloat         _willEndOffsetX;
    //记录滑动结束后的位置
    CGFloat         _endOffsetX;
    
    NSInteger  kMaxNumber;

}
///滚动view 用以承载view
@property (nonatomic,strong) UIScrollView *scrollView;
///最左侧
@property (nonatomic,strong) UIImageView *leftImageView;
///居中的
@property (nonatomic,strong) UIImageView *middleImageView;
///最右侧
@property (nonatomic,strong) UIImageView *rightImageView;
///当前显示的位置
@property (nonatomic,assign) NSInteger currentIndex;
///定时器
@property (nonatomic,assign) CFRunLoopTimerRef timer;

@property (nonatomic,assign) NSTimeInterval timeinterval;

@end
@implementation DHScrollerTView
- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initialize];
    }
    return self;
}
- (void)initialize
{
    self.currentIndex = 0;
    _startOffsetX = 0;
    _willEndOffsetX = 0;
    _endOffsetX = 0;
    self.timeinterval = 2.0;
    kMaxNumber = 3;
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor greenColor];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(00);
        make.right.equalTo(self).offset(00);
        make.height.equalTo(self).offset(0);
    }];
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
- (void)loadImage{
//    if (<#condition#>) {
//        <#statements#>
//    }
}
- (void)tap:(UITapGestureRecognizer *)tap{
    
}

//即将开始拖拽的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //拖动前的起始坐标
    _startOffsetX = scrollView.contentOffset.x;
    
//    [self pauseTimer];
}

//停止拖拽的时候
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self startTimer];
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
    
   
}


- (UIScrollView *)scrollView
{
    if (nil == _scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.layer.borderColor = [UIColor greenColor].CGColor;
        _scrollView.layer.borderWidth = 1.0;
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        _scrollView.contentSize = CGSizeMake(kMaxNumber * self.bounds.size.width, self.bounds.size.height);
        _scrollView.delegate = self;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
