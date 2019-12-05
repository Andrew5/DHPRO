//
//  TMotionViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/14.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "TMotionViewController.h"
#import "WLBallView.h"
#import "WLBallTool.h"
@interface TMotionViewController ()
@property (nonatomic, strong) NSArray * array;

@end

@implementation TMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.array = @[@"大师球",@"高级球",@"超级球",@"精灵球"];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	CGPoint point = [[touches anyObject] locationInView:self.view];
	WLBallView * ballView = [[WLBallView alloc] initWithFrame:CGRectMake(point.x, point.y, 50, 50) AndImageName:self.array[arc4random_uniform(4)]];
	[self.view addSubview:ballView];
	[ballView starMotion];
}

- (void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
	
	[[WLBallTool shareBallTool] stopMotionUpdates];
	
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
