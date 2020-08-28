//
//  IndexViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/5/7.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()
{
	NSArray *arr_Color;
}
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//	[self loadData];
//	[self loadUI];
    // Do any additional setup after loading the view.
	//延时执行
	[self performSelector:@selector(addAD)
			   withObject:nil
			   afterDelay:3.0];
	
	[self loadRectView];
}
//广告条
-(void)addAD
{
	UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, DH_DeviceHeight-60, DH_DeviceWidth, 40)];
	adView.backgroundColor = [UIColor redColor];
	[self scrollerLabelWithView:adView];
	[self.view addSubview:adView];

	UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	closeBtn.frame = CGRectMake(DH_DeviceWidth-20, 10, 20, 20);
	[closeBtn setTitle:@"×" forState:UIControlStateNormal];
	[closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
	[adView addSubview:closeBtn];
	
}
-(void)close:(UIButton *)sender
{
	[sender.superview removeFromSuperview];
}



- (void)loadData{
	arr_Color = @[[UIColor blueColor],
				  [UIColor redColor],
				  [UIColor greenColor],
				  [UIColor yellowColor]];
	
}
- (void)loadUI{
	CGFloat w = 300;
	CGFloat h = 300;
	for (int i = 0; i<4; i++) {
		UIView *aView = [[UIView alloc]init];
		aView.tag = 1000+i;
		aView.frame = CGRectMake(10, 10, w, h);
		aView.center = CGPointMake(160,240);
		[self.view addSubview:aView];
		w -= 20;
		h -= 20;
	}
	[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(change:) userInfo:nil repeats:YES];

}
- (void)change:(NSTimer *)timer{
	for (UIView *aView in self.view.subviews) {
		int i= arc4random()%4;
		aView.backgroundColor = arr_Color[i];
		
	}
}


//小游戏
- (void)loadRectView{
	for (int i = 0; i< 7; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			[btn setImage:[UIImage imageNamed:@"h.png"] forState:UIControlStateNormal];
			[btn setImage:[UIImage imageNamed:@"g.png"] forState:UIControlStateSelected];
			btn.frame = CGRectMake(85+j*60, 100+i*60, 48, 48);
			btn.tag = 1000+i*4+j;
			[btn addTarget:self action:@selector(changes:) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:btn];
		}
	}
}
-(void)changes:(UIButton *)sender
{
	int cTag = (int)sender.tag - 1000;
	
	int lTag = cTag - 1;
	int rTag = cTag + 1;
	int uTag = cTag - 4;
	int dTag = cTag + 4;
	
	
	if (sender.selected)
	{
		[sender setSelected:NO];
	}
	else
	{
		[sender setSelected:YES];
	}
	
	for (UIButton *b in self.view.subviews)
	{
		int vTag = (int)b.tag - 1000;
		if (vTag ==lTag || vTag==rTag || vTag == uTag || vTag == dTag)
		{
			if (b.selected)
			{
				[b setSelected:NO];
			}
			else
			{
				[b setSelected:YES];
			}
		}
	}
}
//无线滚动条
- (void)scrollerLabelWithView:(UIView *)view{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.height/4, view.width-40, view.height)];

	label.text = @"两块钱,你买不了吃亏,两块钱,你买不了上当,真正的物有所值,拿啥啥便宜,买啥啥不贵,都两块,买啥都两块,全场卖两块,随便挑,随便选,都两块！";
	//	label.backgroundColor = [UIColor redColor];
	label.layer.borderColor = [UIColor redColor].CGColor;
	label.layer.borderWidth = 0.3;
	label.textColor = [UIColor blackColor];
	
	[label sizeToFit];
	CGRect frame = label.frame;
	frame.origin.x = 320;
	label.frame = frame;
	
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:12.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationRepeatCount:999999];
	
	frame = label.frame;
	frame.origin.x = -frame.size.width;
	label.frame = frame;
	[UIView commitAnimations];
	[view addSubview:label];
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
