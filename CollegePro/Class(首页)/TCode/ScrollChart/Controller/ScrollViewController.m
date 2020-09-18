//
//  ScrollViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/18.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "ScrollViewController.h"
#import "iCarousels.h"
#import "ZJBLTimerButton.h"

#define ITEM_SPACING 520

@interface ScrollViewController ()<iCarouselDataSource,iCarouselDelegate,UIScrollViewDelegate>
{
    int pageWidth;
    UIScrollView * myScrollView;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    
    int currentImageCount;
    
    UITapGestureRecognizer * tap;
    UIPageControl * myPageControl;
    
    NSMutableArray *infoarray;
    float oldX;
    ///循环显示
    NSTimer         * _animationTimer;
    UIView          *_scrollerView,*_scrollerView2;///场景
    UIView          *_sprite;
    NSTimer         *_spriteTimer;
}
@property (strong, nonatomic) iCarousels *iCarouselView;

@end

@implementation ScrollViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"";
//    [self initWithArray];
//    [self initScrollView];
//    [self addMyPageControl];
//    [self loadScrollViewSubViews];
//    [self initiCarousels];
//    [self initTimerButton];
//    [self buildSubViewsInScrollView:myScrollView];
    ///实现steve游戏效果
    [self runloopScroller];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [_spriteTimer invalidate];
    [_animationTimer invalidate];
    _scrollerView.frame = CGRectMake(0, 100, DH_DeviceWidth, 50);
    _scrollerView2.frame = CGRectMake(DH_DeviceWidth, 100, DH_DeviceWidth, 50);
    _sprite.frame = CGRectMake(100, 400, 50, 50);

}
- (void)runloopScroller{
    _scrollerView = [[UIView alloc]init];
    _scrollerView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_scrollerView];
    _scrollerView.frame = CGRectMake(0, 100, DH_DeviceWidth, 50);
    
    _scrollerView2 = [[UIView alloc]init];
    _scrollerView2.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollerView2];
    _scrollerView2.frame = CGRectMake(DH_DeviceWidth, 100, DH_DeviceWidth, 50);
    
    _sprite = [[UIView alloc]init];
    _sprite.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_sprite];
    _sprite.frame = CGRectMake(100, 400, 50, 50);
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getinternet:) userInfo:nil repeats:YES];
    [_animationTimer setFireDate:[NSDate date]];

}
- (void)getinternet:(NSTimer *)timer{
//    abs（value） 处理int类型value的取绝对值
//    labs（value） 处理long类型value的取绝对值
//    fabsf(value)  处理float类型value的取绝对值
//    fabs(value)   处理double类型value的取绝对值
    [UIView animateWithDuration:0.1 animations:^{
        // 执行动画
        CGRect frame = _scrollerView.frame;
        frame.origin.x -= 1;
        _scrollerView.frame = frame;
        
        CGRect frameframe = _scrollerView2.frame;
        frameframe.origin.x -= 1;
        _scrollerView2.frame = frameframe;
        
    } completion:^(BOOL finished) {
    }];
    ///当绿色走出屏幕外
    if (fabs(_scrollerView.frame.origin.x) >= DH_DeviceWidth) {
        CGRect frame1 = _scrollerView.frame;
        frame1.origin.x = DH_DeviceWidth;
        _scrollerView.frame = frame1;
    }
    ///当红色走出屏幕外
    if (fabs(_scrollerView2.frame.origin.x) >= DH_DeviceWidth) {
        CGRect frame2 = _scrollerView2.frame;
        frame2.origin.x = DH_DeviceWidth;
        _scrollerView2.frame = frame2;
    }
    [UIView animateWithDuration:1 animations:^{
        [_scrollerView layoutIfNeeded];
    }];
    NSLog(@"游戏中的场景：%.2f",_scrollerView.frame.origin.x);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    _spriteTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(spriteTime:) userInfo:nil repeats:YES];
    [_spriteTimer setFireDate:[NSDate date]];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _spriteTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(spriteTime:) userInfo:nil repeats:YES];
    [_spriteTimer setFireDate:[NSDate date]];
    
    [UIView animateWithDuration:1 animations:^{
        // 执行动画
        CGRect frame = _sprite.frame;
        frame.origin.y += 10;
        _sprite.frame = frame;
        NSLog(@"精灵轴Y：%.2f",_sprite.frame.origin.y);

    } completion:^(BOOL finished) {
        
    }];
    if (fabs(_sprite.frame.origin.y) >= 400) {
        [_spriteTimer invalidate];
    }
}
- (void)spriteTime:(NSTimer *)timer{
    [UIView animateWithDuration:1 animations:^{
        // 执行动画
        CGRect frame = _sprite.frame;
        frame.origin.y -= 10;
        _sprite.frame = frame;
        NSLog(@"精灵轴Y：%.2f",_sprite.frame.origin.y);

    } completion:^(BOOL finished) {
    }];
}
-(void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.repeatCount = MAXFLOAT;
    animation.fillMode= kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 8.0;
    animation.toValue = [NSNumber numberWithFloat:-1 * _scrollerView.frame.size.width];
    [_scrollerView.layer addAnimation:animation forKey:nil];
//    _scrollerView.toValue = [NSNumber numberWithFloat:0];
}
-(void)stopAnimation {
    [_scrollerView.layer removeAllAnimations];
    [_scrollerView.layer removeAllAnimations];
}
- (void)initTimerButton{
    //时间按钮
    ZJBLTimerButton *TimerBtn = [[ZJBLTimerButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height-100, 150, 50)];
    __weak typeof(self) WeakSelf = self;
    TimerBtn.countDownButtonBlock = ^{
        [WeakSelf qurestCode]; //开始获取验证码
    };
    [self.view addSubview:TimerBtn];
}
- (void)initiCarousels{
    iCarousels *iCarouselView = [[iCarousels alloc] initWithFrame:CGRectMake(10.0 ,64.0 ,self.view.bounds.size.width-20 ,400)];
    iCarouselView.layer.borderColor = [UIColor redColor].CGColor;
    iCarouselView.layer.borderWidth = 1.0;
    iCarouselView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
    [self.view addSubview:iCarouselView];
    self.iCarouselView = iCarouselView;
    self.iCarouselView.delegate = self;
    self.iCarouselView.dataSource = self;
    self.iCarouselView.type = iCarouselTypeCylinder;//设置图片切换的类型
}
- (void)initScrollView{
    currentImageCount = 0;
    pageWidth = [UIScreen mainScreen].bounds.size.width;
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width-20, 200)];
    [myScrollView setDelegate:self];
    [myScrollView setContentSize:CGSizeMake(pageWidth*3, 100)];
    // [myScrollView setBackgroundColor:[UIColor clearColor]];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    [myScrollView setPagingEnabled:YES];
    //[myScrollView setContentOffset:CGPointMake(pageWidth, 0)];
    [self.view addSubview:myScrollView];
    myScrollView.layer.borderColor = [UIColor greenColor].CGColor;
    myScrollView.layer.borderWidth = 1.0;
    
}
//初始化数组
-(void)initWithArray{
    infoarray = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=1;i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i]];
        [infoarray addObject:image];
    }
}
#pragma mark -
#pragma mark 加上ImageView看看效果
- (void)loadScrollViewSubViews
{
    imageView1 = [[UIImageView alloc] initWithImage:[infoarray objectAtIndex:0]];
    imageView2 = [[UIImageView alloc] initWithImage:[infoarray objectAtIndex:1]];
    imageView3 = [[UIImageView alloc] initWithImage:[infoarray objectAtIndex:2]];
    
    [imageView1 setFrame:CGRectMake(          0, 0, pageWidth, 430)];
    [imageView2 setFrame:CGRectMake(  pageWidth, 0, pageWidth, 430)];
    [imageView3 setFrame:CGRectMake(2*pageWidth, 0, pageWidth, 430)];
    
    [myScrollView addSubview:imageView1];
    [myScrollView addSubview:imageView2];
    [myScrollView addSubview:imageView3];
}

#pragma mark -
#pragma mark 交换图片
- (void)nextImageViewWithImageNumber:(int)number
{
    //向左滑动
    NSLog(@"向左滑动nextImageNumber-----%d",number);
    UIImage * temp = [imageView2.image retain];
    imageView1.image = temp;
    imageView2.image = imageView3.image;
    if(number+1 < infoarray.count)
        imageView3.image = [infoarray objectAtIndex:number+1];
    else
    {
        imageView3.image = [UIImage imageNamed:@""];
        imageView3.backgroundColor = [UIColor clearColor];
    }
    [temp release];
}

- (void)previousImageViewWithImageNumber:(int)number
{
    NSLog(@"previousImageNumber-----%d",number);
    //如果当前页为最前页面 则将当前页的前一视图设为空
    UIImage * temp = [imageView2.image retain];
    imageView3.image = temp ;
    imageView2.image = imageView1.image;
    if(number-1 >= 0)
        imageView1.image = [infoarray objectAtIndex:number-1];
    else{
        imageView1.image = [UIImage imageNamed:@""];
        imageView1.backgroundColor= [UIColor clearColor];
    }
    [temp release];
}

#pragma mark -
#pragma mark AddPageControl
- (void)addMyPageControl
{
    myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, 430, 100, 20)];
    [myPageControl setNumberOfPages:5];
    [myPageControl setCurrentPage:currentImageCount];
    [self.view addSubview:myPageControl];
}

- (void)buildSubViewsInScrollView:(UIScrollView *)scrollView {
    for (int i = 0; i < scrollView.contentSize.width / CGRectGetWidth(scrollView.bounds); i++) {
        for (int j = 0; j < scrollView.contentSize.height / CGRectGetHeight(scrollView.bounds); j++) {
            UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(scrollView.bounds) * i, CGRectGetHeight(scrollView.bounds) * j, CGRectGetWidth(scrollView.bounds), CGRectGetHeight(scrollView.bounds))];
            [self addButtonForView:infoView];
            infoView.backgroundColor = [self randomColor];
            [scrollView addSubview:infoView];
        }
    }
}
- (void)addButtonForView:(UIView *)view {
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(0, 0, 80, 80);
    testButton.backgroundColor = [self randomColor];
    testButton.layer.borderColor = [UIColor greenColor].CGColor;
    testButton.layer.borderWidth = 1.0;
    [testButton addTarget:self action:@selector(testActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:testButton];
}
- (UIColor *)randomColor {
    CGFloat rColor = arc4random() % 256 / 256.0;
    CGFloat gColor = arc4random() % 256 / 256.0;
    CGFloat bColor = arc4random() % 256 / 256.0;
    
    return [UIColor colorWithRed:rColor green:gColor blue:bColor alpha:1];
}
- (void)testActionButton:(UIButton *)but{
    myScrollView.delaysContentTouches = NO;
//    myScrollView.canCancelContentTouches = NO;

}
#pragma mark -
#pragma mark UIScrollViewDelegate
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。  1
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (scrollView.contentOffset.x <= 0)
    //    {
    //            //向右偏移
    //        if(currentImageCount == 0)
    //        {
    //            return;
    //        }
    //            currentImageCount--;
    //            [self previousImageViewWithImageNumber:currentImageCount];
    //            [scrollView setContentOffset:CGPointMake(pageWidth, 0)];
    //    }
    //    if(scrollView.contentOffset.x >= 0)
    //    {
    //        if(currentImageCount== infoarray.count-1)
    //        {
    //            return;
    //        }
    //    }
    //    if (scrollView.contentOffset.x >= 2*pageWidth) {
    //       {
    //           currentImageCount++;
    //            [self nextImageViewWithImageNumber:currentImageCount];
    //            [scrollView setContentOffset:CGPointMake(pageWidth, 0)];
    //        }
    //    }
    //
    static float newX = 0;
    //_oldY 记录刚开始的便宜量
    newX = scrollView.contentOffset.x;
    if (newX != oldX) {
        if (newX > oldX) {
            NSLog(@"右滑");
            oldX = newX;
            if(currentImageCount == 0)
            {
                return;
            }
            currentImageCount--;
            [self previousImageViewWithImageNumber:currentImageCount];
            [scrollView setContentOffset:CGPointMake(pageWidth, 0)];
        } else if (newX < oldX) {
            NSLog(@"左滑");
            oldX = newX;
            if(currentImageCount== infoarray.count-1)
            {
                return;
            }
            if (scrollView.contentOffset.x >= 2*pageWidth)
            {
                currentImageCount++;
                [self nextImageViewWithImageNumber:currentImageCount];
                [scrollView setContentOffset:CGPointMake(pageWidth, 0)];
            }
        }
        
    }
    
}
//加速度停止后，回到中间，带动画效果
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // [scrollView setContentOffset:CGPointMake(pageWidth, 0) animated:YES];
}
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView{
    return nil;
}
                                             // any offset changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
} API_AVAILABLE(ios(3.2)); // any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
} API_AVAILABLE(ios(5.0));
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}   // called on finger up as we are moving

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
} // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    
} API_AVAILABLE(ios(3.2)); // called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
} // scale between minimum and maximum. called after any 'bounce' animations

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}   // return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}      // called when scrolling animation finished. may be called immediately if already at top

/* Also see -[UIScrollView adjustedContentInsetDidChange]
 */
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView{
    
}
//发生网络请求 --> 获取验证码
- (void)qurestCode {
	
	NSLog(@"发生网络请求 --> 获取验证码");
	
	
}

#pragma mark-

//一共有几个切换的图片
-(NSUInteger)numberOfItemsInCarousel:(iCarousels *)carousel {
	
	return 7;
	
}

-(UIView *)carousel:(iCarousels *)carousel viewForItemAtIndex:(NSUInteger)index {
	
	UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"0%lu.png",(unsigned long)index]]];
	
	view.frame = CGRectMake(100, 50, 100, 100);
	return view;
	
}

-(NSUInteger)numberOfPlaceholdersInCarousel:(iCarousels *)carousel {
	return 0;
}

//一共有几个show切换的图片
-(NSUInteger) numberOfVisibleItemsInCarousel:(iCarousels *)carousel {
	return 7;
}

//图片之间的间隔宽
-(CGFloat)carouselItemWidth:(iCarousels *)carousel {
	
	return ITEM_SPACING;
}


- (CATransform3D)carousel:(iCarousels *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
	view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
	
	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = self.iCarouselView.perspective;
	transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
	return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.iCarouselView.itemWidth);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [super dealloc];
    
    [myScrollView removeGestureRecognizer:tap];
    [myScrollView removeFromSuperview];
    [myScrollView release];
    
    [imageView1 removeFromSuperview];
    [imageView1 release];
    
    [imageView2 removeFromSuperview];
    [imageView2 release];
    
    [imageView3 removeFromSuperview];
    [imageView3 release];
    
    [tap release];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
	
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
	
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
	
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
	return  CGSizeZero;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
	
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
	
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
	
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator  API_AVAILABLE(ios(9.0)) API_AVAILABLE(ios(9.0)){
	
}

- (void)setNeedsFocusUpdate {
	
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context  API_AVAILABLE(ios(9.0)){
	return YES;
}

- (void)updateFocusIfNeeded {
	
}

@end
