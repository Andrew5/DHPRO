//
//  BaseNavigationController.m
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTabBarViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
//{
//    UIView *alphaView;
//}

//-(id)initWithRootViewController:(UIViewController *)rootViewController{
//    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//        CGRect frame = self.navigationBar.frame;
//        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
////        alphaView.backgroundColor = IWColor(255,155,0);
//        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
//        self.navigationBar.layer.masksToBounds = YES;
//    }
//    return self;
//}
//
//-(void)setBarTransparent:(BOOL)barTransparent
//{
//    _barTransparent =barTransparent;
//    if(barTransparent == YES){
//        [UIView animateWithDuration:0.5 animations:^{
//            alphaView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            alphaView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//        }];
//    }
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupBase];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moreMore:) name:@"moreMore" object:nil];
    // Do any additional setup after loading the view.
}
/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
//+ (void)initialize
//{
//	// 1.设置导航栏主题
//	[self setupNavBarTheme];
//	
//	// 2.设置导航栏按钮主题
//	[self setupBarButtonItemTheme];
//}
//
///**
// *  设置导航栏按钮主题
// */
//+ (void)setupBarButtonItemTheme
//{
//	UIBarButtonItem *item = [UIBarButtonItem appearance];
//	
//	// 设置文字属性
//	NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//	textAttrs[UITextAttributeTextColor] = [UIColor redColor];//iOS7 ? [UIColor colorWithRed:0.129 green:0.620 blue:0.600 alpha:1.000] : [UIColor redColor];
//	textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//	textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:15];
//	[item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//	[item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
//	
//	NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//	disableTextAttrs[UITextAttributeTextColor] =  [UIColor lightGrayColor];
//	[item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
//	/*
//	 // 设置文字属性
//	 NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//	 textAttrs[NSForegroundColorAttributeName] = fontColor;//iOS7 ? [UIColor colorWithRed:0.129 green:0.620 blue:0.600 alpha:1.000] : [UIColor redColor];
//	 //    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
//	 textAttrs[NSFontAttributeName] = BAKit_Font_systemFontOfSize_18;
//	 [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//	 [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
//	 
//	 NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//	 disableTextAttrs[NSForegroundColorAttributeName] =  [UIColor lightGrayColor];
//	 [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
//	 */
//	
//}
//
///**
// *  设置导航栏主题
// */
//+ (void)setupNavBarTheme
//{
//	
//	[[UINavigationBar appearance] setBarTintColor:[UIColor lightGrayColor]];//[UIColor colorWithRed:0.177 green:0.863 blue:0.839 alpha:1.000]];
//	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//	
//}
//
////删除tabbar 上的uitabbarbutton
//-(void)moreMore:(UIViewController *)vc
//{
//	for (UIView *subView in vc.tabBarController.tabBar.subviews) {
//		if ([subView isKindOfClass:[UIControl class]]) {
//			subView.hidden = YES;
//			[subView removeFromSuperview];
//		}
//	}
//	
//}
//-(void)dealloc
//{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"moreMore" object:nil];
//}


- (void)setupBase{
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	//导航栏背景颜色
	UINavigationBar *naviBar = [UINavigationBar appearance];
	naviBar.barTintColor = DHColor(0.1, 0.1, 0.1);
	naviBar.tintColor = [UIColor whiteColor];
	naviBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
	
	//设置导航条的背景色
	[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
	
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
