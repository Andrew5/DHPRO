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
}
@property (strong, nonatomic) iCarousels *iCarouselView;

@end

@implementation ScrollViewController
//初始化数组
-(void)initWithArray
{
    infoarray = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i=1;i<=13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i]];
        [infoarray addObject:image];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor =[UIColor whiteColor];
	iCarousels *iCarouselView = [[iCarousels alloc] initWithFrame:CGRectMake(10.0 ,64.0 ,self.view.bounds.size.width-20 ,400)];
    iCarouselView.layer.borderColor = [UIColor redColor].CGColor;
    iCarouselView.layer.borderWidth = 1.0;
	iCarouselView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
	[self.view addSubview:iCarouselView];
	self.iCarouselView = iCarouselView;
	self.iCarouselView.delegate = self;
	self.iCarouselView.dataSource = self;
	self.iCarouselView.type = iCarouselTypeCylinder;//设置图片切换的类型
    [self createUI];
    // Do any additional setup after loading the view.
	
	//时间按钮
	ZJBLTimerButton *TimerBtn = [[ZJBLTimerButton alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height-100, 150, 50)];
	__weak typeof(self) WeakSelf = self;
	TimerBtn.countDownButtonBlock = ^{
		[WeakSelf qurestCode]; //开始获取验证码
	};
	[self.view addSubview:TimerBtn];
	
}
- (void)createUI{
    [self initWithArray];
    currentImageCount = 0;
    pageWidth = 320;
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.iCarouselView.width, 400)];
    [myScrollView setDelegate:self];
    [myScrollView setContentSize:CGSizeMake(pageWidth*3, 430)];
    // [myScrollView setBackgroundColor:[UIColor clearColor]];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    [myScrollView setPagingEnabled:YES];
    //[myScrollView setContentOffset:CGPointMake(pageWidth, 0)];
    [self.iCarouselView addSubview:myScrollView];
    [self addMyPageControl];
    
    [self loadScrollViewSubViews];
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

#pragma mark -
#pragma mark UIScrollViewDelegate
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
    //增加PageControl直观显示当前滑动位置
    [myPageControl setCurrentPage:currentImageCount];
    
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

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
	
}

- (void)setNeedsFocusUpdate {
	
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
	return YES;
}

- (void)updateFocusIfNeeded {
	
}

@end
