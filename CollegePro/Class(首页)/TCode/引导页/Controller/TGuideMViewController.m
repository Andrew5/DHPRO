//
//  TGuideMViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/14.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "TGuideMViewController.h"
#import "KSGuideManager.h"

@interface TGuideMViewController ()

@end

@implementation TGuideMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUPUI];
    // Do any additional setup after loading the view.
}
- (void)setUPUI{
	NSMutableArray *paths = [NSMutableArray new];
	//	for (int i = 0; i < pageCount; i ++) {
	//
	//		[paths addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"0%d",i+1] ofType:@"jpg"]];
	//
	//		[[KSGuideManager shared] showGuideViewWithImages:paths];
	//
	//
	//	}
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"01" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"02" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"03" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"04" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"04" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"05" ofType:@"png"]];
	[paths addObject:[UIImage imageNamed:@"01"]];
	[paths addObject:[UIImage imageNamed:@"02"]];
	[paths addObject:[UIImage imageNamed:@"03"]];
	[paths addObject:[UIImage imageNamed:@"04"]];
	[paths addObject:[UIImage imageNamed:@"05"]];
	[paths addObject:[UIImage imageNamed:@"06"]];
	[paths addObject:[UIImage imageNamed:@"07"]];
	[paths addObject:[UIImage imageNamed:@"08"]];

	
	[[KSGuideManager shared] showGuideViewWithImages:paths];

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
