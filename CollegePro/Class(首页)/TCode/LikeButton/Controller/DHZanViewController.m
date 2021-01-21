
//
//  DHZanViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/23.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHZanViewController.h"
#import "MBProgressHUD.h"
#import "DHBlueButton.h"

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
    
    ///TODO:两个view操作
    UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = CGRectMake(20, 150, 200, 200);
    [redBtn setTitle:@"1" forState:UIControlStateNormal];
    [redBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    redBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:redBtn];
    
    DHBlueButton *blueBtn = [[DHBlueButton alloc] initWithFrame:CGRectMake(170, 300, 200, 200)];
    [blueBtn setTitle:@"2" forState:UIControlStateNormal];
    [blueBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    blueBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueBtn];
    blueBtn.redButton = redBtn;
    
    [redBtn addTarget:self action:@selector(abc) forControlEvents:(UIControlEventTouchUpInside)];
    [blueBtn addTarget:self action:@selector(def) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)abc{
    NSLog(@"点击 %s",__func__);
}
- (void)def{
    NSLog(@"点击 %s",__func__);
}
- (void)praiseTopic:(UIButton *)sender{
	if (sender.selected == YES) {
		NSLog(@"点赞");
		[sender setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
         MBProgressHUD *hub=[[MBProgressHUD alloc] initWithView:self.view];

        hub.mode=MBProgressHUDModeIndeterminate;

        hub.labelText=@"发送中。。。";

//        [self.view addSubview:hub];

        [hub show:YES];

        [hub hide:YES afterDelay:5];
        
        hub.userInteractionEnabled = NO;
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
