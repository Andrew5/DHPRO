//
//  LBTabBarTextController.m
//  Test
//
//  Created by Rillakkuma on 2017/12/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//
#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_TAB_BAR_HEIGHT               49
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
//程序进去默认选择第几个tabar
#define DEFAULTSELECTINDEX 0
#define APPMAINCOLOR [UIColor colorWithRed:0.76 green:0.13 blue:0.25 alpha:1]
#define btn_tag 10001
#define WIDTH(v)                (v).frame.size.width
#import "LBTabBarTextController.h"
#import "NTButton.h"

//
#import "AutoLayoutViewController.h"
#import "ReleaseViewController.h"
#import "DetailsDrawViewController.h"
#import "YSYPreviewViewController.h"
#import "PostTableViewController.h"
//
@interface LBTabBarTextController ()

@end

@implementation LBTabBarTextController
static LBTabBarTextController *sharedBaseTabBar;
+ (LBTabBarTextController *)sharedBaseTabBarViewController {
	
	//	static dispatch_once_t onceToken;
	//	dispatch_once(&onceToken, ^{
	if (!sharedBaseTabBar) {
		sharedBaseTabBar = [[LBTabBarTextController alloc] init];
		sharedBaseTabBar.view.backgroundColor = [UIColor redColor];
		NSLog(@"初始化");
	}
	//	});
	return sharedBaseTabBar;
}
+(LBTabBarTextController *)destoryShared{
	return sharedBaseTabBar = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	AutoLayoutViewController * vc1 = [[AutoLayoutViewController alloc] init];
	ReleaseViewController * vc2 = [[ReleaseViewController alloc] init];
	DetailsDrawViewController * vc3 = [[DetailsDrawViewController alloc] init];
	PostTableViewController * vc5 = [[PostTableViewController alloc] init];
	NSInteger tabNum = 5;
	NSArray *titleArr;
	self.viewControllers = @[vc1,vc2,vc3,vc5];
	titleArr =@[@"",@"首页",@"发现",@"",@"消息",@"我的"];
	
	self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, UI_TAB_BAR_HEIGHT)];
	_bgView.backgroundColor = [UIColor whiteColor];
	_bgView.userInteractionEnabled = YES;
	//去掉顶部的黑线
//	[[UITabBar appearance] setShadowImage:[UIImage new]];
//	[[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
	UILabel *linel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.1)];
	linel.backgroundColor = [UIColor blackColor];
	[_bgView addSubview:linel];
	[self.tabBar addSubview:_bgView];
	
	
	redView = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
	redView.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
	redView.layer.masksToBounds = YES;
	redView.layer.cornerRadius = 5;
	redView.hidden = YES;
	
	redView1 = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
	redView1.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
	redView1.layer.masksToBounds = YES;
	redView1.layer.cornerRadius = 5;
	redView1.hidden = YES;
	
	findRedView = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
	findRedView.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
	findRedView.layer.masksToBounds = YES;
	findRedView.layer.cornerRadius = 5;
	findRedView.hidden = YES;
	
	
	for (int i = 0; i < tabNum; i ++)
	{
		if (i!=2) {
			NTButton *button = [NTButton buttonWithType:UIButtonTypeCustom];
			button.frame = CGRectMake(i*UI_SCREEN_WIDTH/(tabNum),0,UI_SCREEN_WIDTH/(tabNum),UI_TAB_BAR_HEIGHT);
			button.enabled = i==DEFAULTSELECTINDEX?NO:YES;
			[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d",i+1]] forState:UIControlStateNormal];
			[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected",i+1]] forState:UIControlStateDisabled];
			[button setTitle:titleArr[i+1] forState:UIControlStateNormal];
			[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
			[button setTitleColor:APPMAINCOLOR forState:UIControlStateDisabled];
			button.titleLabel.font =[UIFont systemFontOfSize:10];
			button.titleLabel.textAlignment =NSTextAlignmentCenter;
			[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected",i+1]] forState:UIControlStateDisabled];
			button.contentMode =UIViewContentModeCenter;
			button.clipsToBounds =YES;
			
			[button addTarget:self action:@selector(chooseTabBar:) forControlEvents:UIControlEventTouchUpInside];
			button.adjustsImageWhenHighlighted =NO;
			button.tag = btn_tag+i;
			if (!button.enabled){
				[self setSelectedIndex:i];
				_beforeIndex = i;
				_presentIndex = i;
			}
			[_bgView addSubview:button];
			
			if (i ==1) {
				[button addSubview:findRedView];
			}
			if (i==3) {
				[button addSubview:redView];
			}
			if (i==4) {
				[button addSubview:redView1];
			}
		}
	}
	
	centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	centerBtn.backgroundColor = [UIColor clearColor];
	[centerBtn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:0];
	centerBtn.frame = CGRectMake(2*UI_SCREEN_WIDTH/(tabNum),-40,UI_SCREEN_WIDTH/(tabNum),UI_TAB_BAR_HEIGHT+40);
//	[centerBtn setTitle:@"" forState:UIControlStateNormal];
//	[centerBtn setTitleColor:APPMAINCOLOR forState:UIControlStateDisabled];
	centerBtn.titleLabel.font =[UIFont systemFontOfSize:10];
	[centerBtn setTitleEdgeInsets:UIEdgeInsetsMake(70,-50,0, 0)];
	[centerBtn setImageEdgeInsets:UIEdgeInsetsMake(0,(WIDTH(centerBtn)-50)/2.0,0, 0)];
	[centerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	
	[centerBtn addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
	[_bgView addSubview:centerBtn];
	
    // Do any additional setup after loading the view.
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
//    if (self.isHidden == NO) {
        
        CGPoint newPoint = [self.view convertPoint:point toView:centerBtn];
        
        if ( [centerBtn pointInside:newPoint withEvent:event]) {
            return centerBtn;
        }else{
            
            return [self hitTest:point withEvent:event];
        }
//    }
//
//    else {
//        return [super hitTest:point withEvent:event];
//    }
    
    
}
-(void)centerClick{
	YSYPreviewViewController * vc4 = [[YSYPreviewViewController alloc] init];
	//发起预约
//	UIViewController *dv = [UIViewController new];
	
	[self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc4] animated:YES completion:NULL];
}

-(void)chooseTabBar:(UIButton *)sender
{
	_presentIndex = sender.tag-btn_tag;
	[self confirmSelectTabBar:_presentIndex];
	[self setSelectedIndex:_presentIndex];
	_beforeIndex = _presentIndex;
}
-(void)confirmSelectTabBar:(NSInteger)selectIndex
{
	for (UIButton * button in [_bgView subviews]){
		if ([button isKindOfClass:[UIButton class]]){
			button.enabled= button.tag==selectIndex+10001?NO:YES;
		}
	}
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
