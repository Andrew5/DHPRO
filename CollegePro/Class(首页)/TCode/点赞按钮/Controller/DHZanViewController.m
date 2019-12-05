
//
//  DHZanViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/23.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHZanViewController.h"

@interface DHZanViewController ()

@end

@implementation DHZanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUPUI];
    // Do any additional setup after loading the view.
}
- (void)setUPUI{
	UIButton * praiseView = [UIButton buttonWithType:UIButtonTypeCustom];
	[praiseView setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
	[praiseView.titleLabel setFont:[UIFont systemFontOfSize:12]];
	[praiseView setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
	[praiseView addTarget:self action:@selector(praiseTopic:) forControlEvents:UIControlEventTouchUpInside];
	praiseView.frame = CGRectMake(100, 100, 40, 30);
	[praiseView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	praiseView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self.view addSubview:praiseView];
}
- (void)praiseTopic:(UIButton *)sender{
	if (sender.selected == YES) {
		NSLog(@"点赞");
		[sender setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];

	}
	else{
		NSLog(@"取消点赞");
		[sender setImage:[UIImage imageNamed:@"hpdianzan"] forState:UIControlStateNormal];

	}
	sender.selected =! sender.selected;

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
