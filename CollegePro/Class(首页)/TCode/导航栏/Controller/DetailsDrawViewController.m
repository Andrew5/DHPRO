//
//  DetailsDrawViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/11/3.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "DetailsDrawViewController.h"
#import "SGSegmentedControl.h"
#import "TestOneVC.h"

#import "TestTwoVC.h"

#import "TestThreeVC.h"

@interface DetailsDrawViewController ()<UIScrollViewDelegate, SGSegmentedControlDelegate>
@property (nonatomic, strong) SGSegmentedControl *SG;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation DetailsDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	// 1.添加所有子控制器
	[self setupChildViewController];
	
	[self setupSegmentedControl];
	
	NSLog(@"时间--%@",[self BA_time_compareTime]);
    // Do any additional setup after loading the view.
}
- (void)setupSegmentedControl {
	
	NSArray *title_arr = @[@"精选", @"电视剧", @"电影"];
	
	// 创建底部滚动视图
	self.mainScrollView = [[UIScrollView alloc] init];
	_mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	_mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * title_arr.count, 0);
	_mainScrollView.backgroundColor = [UIColor clearColor];
	// 开启分页
	_mainScrollView.pagingEnabled = YES;
	// 没有弹簧效果
	_mainScrollView.bounces = NO;
	// 隐藏水平滚动条
	_mainScrollView.showsHorizontalScrollIndicator = NO;
	// 设置代理
	_mainScrollView.delegate = self;
	[self.view addSubview:_mainScrollView];
	
	
	self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:title_arr];
	_SG.titleColorStateSelected = [UIColor purpleColor];
	_SG.indicatorColor = [UIColor redColor];
	[self.view addSubview:_SG];
	
	TestOneVC *oneVC = [[TestOneVC alloc] init];
	[self.mainScrollView addSubview:oneVC.view];
	[self addChildViewController:oneVC];
}


- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
	// 1 计算滚动的位置
	CGFloat offsetX = index * self.view.frame.size.width;
	self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
	
	// 2.给对应位置添加对应子控制器
	[self showVc:index];
}

// 添加所有子控制器
- (void)setupChildViewController {
	// 精选
	TestOneVC *oneVC = [[TestOneVC alloc] init];
	[self addChildViewController:oneVC];
	
	// 电视剧
	TestTwoVC *twoVC = [[TestTwoVC alloc] init];
	[self addChildViewController:twoVC];
	
	// 电影
	TestThreeVC *threeVC = [[TestThreeVC alloc] init];
	[self addChildViewController:threeVC];
	
	
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
	
	CGFloat offsetX = index * self.view.frame.size.width;
	
	UIViewController *vc = self.childViewControllers[index];
	
	// 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
	if (vc.isViewLoaded) return;
	
	[self.mainScrollView addSubview:vc.view];
	vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	// 计算滚动到哪一页
	NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
	
	// 1.添加子控制器view
	[self showVc:index];
	
	// 2.把对应的标题选中
	[self.SG titleBtnSelectedWithScrollView:scrollView];
}


/*! 计算上报时间差 */
- (NSString *)BA_time_compareTime
{
	// 计算上报时间差
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	// 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
	[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
	[formatter setTimeZone:timeZone];
	NSDate *datenow = [NSDate date];
	// 设置一个字符串的时间
    NSMutableString *datestring = [NSMutableString stringWithFormat:@"%ld",20141202052740];
	// 注意 如果20141202052740必须是数字，如果是UNIX时间，不需要下面的插入字符串。
	[datestring insertString:@"-" atIndex:4];
	[datestring insertString:@"-" atIndex:7];
	[datestring insertString:@" " atIndex:10];
	[datestring insertString:@":" atIndex:13];
	[datestring insertString:@":" atIndex:16];
//	BALog(@"datestring==%@",datestring);
	NSDateFormatter * dm = [[NSDateFormatter alloc]init];
	
	//指定输出的格式  这里格式必须是和上面定义字符串的格式相同，否则输出空
	[dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSDate * newdate = [dm dateFromString:datestring];
	long dd = (long)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
	NSString *timeString=@"";
	if (dd/3600<1)
	{
		timeString = [NSString stringWithFormat:@"%ld", dd/60];
		timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
	}
	if (dd/3600>1&&dd/86400<1)
	{
		timeString = [NSString stringWithFormat:@"%ld", dd/3600];
		timeString=[NSString stringWithFormat:@"%@小时前", timeString];
	}
	if (dd/86400>1)
	{
		timeString = [NSString stringWithFormat:@"%ld", dd/86400];
		timeString=[NSString stringWithFormat:@"%@天前", timeString];
	}
//	BALog(@"=====%@",timeString);
	return timeString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
