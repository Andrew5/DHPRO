//
//  SubparagraphViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/18.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "SubparagraphViewController.h"
#import "YPTabBarController.h"
#import "SubparagraphRootViewController.h"
@interface SubparagraphViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@end

@implementation SubparagraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UILabel *label = [[UILabel alloc]init];
	label.frame = CGRectMake(100, 100, 100, 30);
	[self.view addSubview:label];
	self.label = label;
    // Do any additional setup after loading the view.
	
	self.label.text = self.yp_tabItemTitle;
	
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"按钮" forState:UIControlStateNormal];
	button.frame = CGRectMake(100, 100, 100, 50);
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
//	[self.view addSubview:button];
	NSLog(@"viewDidLoad--->%@", self.yp_tabItemTitle);
	


}
- (void)buttonClicked:(UIButton *)button {
	//    self.yp_tabBarController.contentViewFrame = CGRectMake(0, 64, 300, 500);
	[self.navigationController pushViewController:[[SubparagraphViewController alloc] init] animated:YES];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"viewWillAppear--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"viewDidAppear--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSLog(@"viewWillDisappear--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	NSLog(@"viewDidDisappear--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}

- (void)tabItemDidDeselected {
	NSLog(@"Deselected--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}

- (void)tabItemDidSelected {
	NSLog(@"Selected--->%@ %@", NSStringFromClass(self.class), self.yp_tabItemTitle);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)doubleClicked {
	NSLog(@"doubleClicked");
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
