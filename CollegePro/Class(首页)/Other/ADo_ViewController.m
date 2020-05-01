//
//  ADo_ViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/31.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "ADo_ViewController.h"

@interface ADo_ViewController ()<UIScrollViewDelegate>

@end

@implementation ADo_ViewController
-(void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
	self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    /**
     
     背景图片
     
     */
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"page_bg_35"];
    [self.view addSubview:backView];
    
    /**
     
     滚动 辅助作用
     
     */
    UIScrollView *ado_guideView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    ado_guideView.contentSize = CGSizeMake(screenW * pageCount, screenH);
    ado_guideView.bounces = NO;
    ado_guideView.pagingEnabled = YES;
    ado_guideView.delegate = self;
    ado_guideView.showsHorizontalScrollIndicator = NO;
    
    /**
     
     滚动球
     
     */
    UIImageView *picView = [[UIImageView alloc] init];
    picView.width = picH ;
    picView.height = picH;
    picView.centerX = screenW / 2;
    picView.centerY = screenH + padding;
    ///!!!:设置锚点是个坑
    picView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    picView.image = [UIImage imageNamed:@"guider_qiu_35"];
    
    /**
     
     滚动牌
     
     */
    UIImageView *paiView = [[UIImageView alloc] init];
    paiView.width = picH;
    paiView.height = picH;
    paiView.centerX = screenW / 2 ;
    paiView.centerY = screenH + padding;
    paiView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    paiView.image = [UIImage imageNamed:@"guider_pai_35"];
    
    /**
     
     指示器
     
     */
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(screenW / 2 - 50, screenH - 20, 100, 20)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [backView addSubview:pageControl];
    
    /**
     
     顶部滚动图片
     
     */
    UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    topView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * pageCount, [UIScreen mainScreen].bounds.size.height);
    topView.bounces = NO;
    topView.pagingEnabled = YES;
    for (int i = 0; i < pageCount; i ++) {
        UIImageView *topPic = [[UIImageView alloc] init];
        topPic.width = [UIScreen mainScreen].bounds.size.width;
        topPic.height = [UIScreen mainScreen].bounds.size.height;
        topPic.centerX = i * [UIScreen mainScreen].bounds.size.width + [UIScreen mainScreen].bounds.size.width / 2;
        topPic.y = 0;
        NSString *picName = [NSString stringWithFormat:@"0%d",i+1];
        topPic.image = [UIImage imageNamed:picName];
        [topView addSubview:topPic];
        if (i ==4) {
            UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
            [start setTitle:@"立即体验" forState:UIControlStateNormal];
            start.frame = CGRectMake(DH_DeviceWidth*4+(DH_DeviceWidth - 250)/2, DH_DeviceHeight - 150, 250, 44);
            [start addTarget:self action:@selector(Pushpage) forControlEvents:(UIControlEventTouchUpOutside)];
            start.layer.cornerRadius=2;
            start.layer.borderWidth = 1;
            start.layer.borderColor = [[UIColor whiteColor] CGColor];
            start.layer.masksToBounds=YES;
            [topView addSubview:start];
        }
    }
    [backView addSubview:topView];
    self.topView = topView;
    
    self.pageControl = pageControl;
    [self.view addSubview:paiView];
    [self.view addSubview:picView];
    [self.view addSubview:ado_guideView];
    self.guideView = ado_guideView;
    self.picView = picView;
    self.paiView = paiView;
}
- (void)Pushpage{
	self.navigationController.navigationBarHidden =NO;
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - privateMethod

-(void)addGuideController{
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstEnterApp"]) {
			UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
			ADo_ViewController * guide = [storyboard instantiateViewControllerWithIdentifier:@"ado"];
					[self addChildViewController:guide];
			guide.view.frame = self.view.bounds;
			[self.view addSubview:guide.view];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstEnterApp"];
		}
}

/**
 
 * 模态到下个页面
 
 *
 
 */

- (void)go2MainVC:(UIButton *)btn
{
	//UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"你点中我了" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	//[alert show];
 
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	homeViewController *view=[self.storyboard instantiateViewControllerWithIdentifier:@"zhujiemian"];
	[self.navigationController pushViewController:view animated:YES];
}

/**
 
 * scrollView代理方法
 
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float offSetX = scrollView.contentOffset.x;
	self.picView.layer.transform = CATransform3DMakeRotation(-offSetX*(M_PI)/screenW / 3, 0, 0, 1);
	self.paiView.layer.transform = CATransform3DMakeRotation(-offSetX*(M_PI)/screenW / 3, 0, 0, 1);
	self.pageControl.currentPage = scrollView.contentOffset.x / screenW;
 	if (self.pageControl.currentPage == 4) {
			UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW / 2 + offSetX - btnW / 2, screenH - 155, btnW, btnH)];
			[nextBtn addTarget:self action:@selector(go2MainVC:) forControlEvents:UIControlEventTouchUpInside];
			nextBtn.backgroundColor = [UIColor clearColor];
			[scrollView addSubview:nextBtn];
		}
	self.topView.contentOffset = CGPointMake(offSetX, 0);
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
