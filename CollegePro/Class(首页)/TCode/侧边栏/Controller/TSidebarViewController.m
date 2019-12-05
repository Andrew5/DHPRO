//
//  TSidebarViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/14.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "TSidebarViewController.h"
#import "SidebarViewController.h"

#import "ALiAlertView.h"

#import "LabelMethodBlockSubVC.h"
#import "LabelNilMethodBlockViewController.h"
@interface TSidebarViewController ()<UIGestureRecognizerDelegate>
{
	__block UILabel *lb_showinfo;
}
@property (nonatomic, retain) SidebarViewController* sidebarVC;
@property (nonatomic, retain) ALiAlertView*alert;
@end

@implementation TSidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

	[self setUPUI];
    // Do any additional setup after loading the view.
}
- (void)setUPUI{
	
	UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
	[panGesture delaysTouchesBegan];
	[self.view addGestureRecognizer:panGesture];

	__block TSidebarViewController* bObject = self;

	self.sidebarVC = [[SidebarViewController alloc] init];
	self.sidebarVC.myReturnTextBlock = ^(NSString *showText){
		NSLog(@"showText  %@",showText);
		bObject.alert = [[ALiAlertView alloc] init];
		bObject.alert.tapDismissEnable = YES;
		bObject.alert.layer.borderColor = [UIColor orangeColor].CGColor;
		bObject.alert.layer.borderWidth = 1.0;
		bObject->lb_showinfo.hidden = NO;
		bObject->lb_showinfo.text = showText;
		bObject.alert.contentView = bObject->lb_showinfo;
		[bObject.alert show];

	};

	[self.sidebarVC setBgRGB:0x000000];
	[[UIApplication sharedApplication].keyWindow addSubview:self.sidebarVC.view];
	self.sidebarVC.view.frame  = self.view.bounds;
	
	lb_showinfo = [[UILabel alloc]init];
	lb_showinfo.hidden = YES;
	lb_showinfo.textColor = [UIColor redColor];
	lb_showinfo.font = [UIFont systemFontOfSize:14];
	lb_showinfo.frame = CGRectMake(self.view.centerX, self.view.centerY, 100, 100);
	[self.view addSubview:lb_showinfo];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
	CGPoint translatedPoint = [recoginzer translationInView:self.view];
	NSLog(@"translatedPoint %f",translatedPoint.x);
	//向右
	if (translatedPoint.x>0) {
		[self.sidebarVC panDetected:recoginzer];
	}
	
}

-(UIPanGestureRecognizer *)tz_popGestureRecognizer {
	UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
	if (!pan) {
		// 侧滑返回手势 手势触发的时候，让target执行action
		id target = self.navigationController.delegate;
		SEL action = NSSelectorFromString(@"handleNavigationTransition:");
		pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
		pan.maximumNumberOfTouches = 1;
		pan.delegate = self;
		self.navigationController.interactivePopGestureRecognizer.enabled = NO;
		objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return pan;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
	if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
		return NO;
	}
	if (self.childViewControllers.count <= 1) {
		return NO;
	}
	// 侧滑手势触发位置
	CGPoint location = [gestureRecognizer locationInView:self.view];
	CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
	BOOL ret = (0 < offSet.x && location.x <= 40);
	NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
	return ret;
}

- (void)pushBlockMetnod{
	LabelMethodBlockSubVC *subVC = [[LabelMethodBlockSubVC alloc]init];
	[subVC returnText:^(NSString *showText) {
		NSLog(@"--传值--%@",showText);
		
	}];
	
	[self presentViewController:subVC animated:YES completion:^{
		
	}];
}

- (void)pushBlockNilMetnod{
	LabelNilMethodBlockViewController *subVC = [[LabelNilMethodBlockViewController alloc]init];
	
	subVC.myReturnTextBlock = ^(NSString *showText){
		NSLog(@"showText  %@",showText);
		self.alert = [[ALiAlertView alloc] init];
		self.alert.tapDismissEnable = YES;
		lb_showinfo.hidden = NO;
		lb_showinfo.text = showText;
		self.alert.contentView = lb_showinfo;
		
		[self.alert show];
	};
	
	[self presentViewController:subVC animated:YES completion:^{
		
	}];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//	[self.sidebarVC showHideSidebar];
//}
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
