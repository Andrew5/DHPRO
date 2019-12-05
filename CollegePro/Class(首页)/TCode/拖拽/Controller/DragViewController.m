//
//  DragViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/18.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DragViewController.h"
#import "UIImageView+WebCache.h"
#import "WMDragView.h"

@interface DragViewController ()

@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
	WMDragView *logoView = [[WMDragView alloc] initWithFrame:CGRectMake(0, 0 , 120, 120)];
	logoView.layer.cornerRadius = 14;
	logoView.isKeepBounds = NO;
	//设置网络图片
	[logoView.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100"] placeholderImage:[UIImage imageNamed:@"logo1024"]];
	[self.view addSubview:logoView];
	//限定logoView的活动范围
	logoView.freeRect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
	logoView.center = self.view.center;
	
	///点击block
	logoView.ClickDragViewBlock = ^(WMDragView *dragView){
		[dragView.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://weixintest.ihk.cn/ihkwx_upload/userPhoto/15914867203-1461920972642.jpg"] placeholderImage:[UIImage imageNamed:@"logo1024"]];
		NSLog(@"点击block");
		
	};
	///开始拖曳block
	logoView.BeginDragBlock = ^(WMDragView *dragView){
		NSLog(@"开始拖曳");
	};
	
	///结束拖曳block
	logoView.EndDragBlock = ^(WMDragView *dragView){
		NSLog(@"结束拖曳");
		
	};
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
