//
//  PayViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/10/18.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "PayViewController.h"
#import "ZSDPaymentView.h"
#import "CodeView.h"
#import "InputVertifyView.h"
@interface PayViewController ()

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	btn.frame = CGRectMake(50, 100, 50, 50);
	[btn setTitle:@"test" forState:UIControlStateNormal];
	[btn setBackgroundColor:[UIColor greenColor]];
	[btn addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btn];
    // Do any additional setup after loading the view.
	
	UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	viewBtn.frame = CGRectMake(120, 100, 50, 50);
	[viewBtn setTitle:@"test" forState:UIControlStateNormal];
	[viewBtn setBackgroundColor:[UIColor greenColor]];
	[viewBtn addTarget:self action:@selector(addView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:viewBtn];
	
	UIButton *inputVertifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	inputVertifyBtn.frame = CGRectMake(190, 100, 50, 50);
	[inputVertifyBtn setTitle:@"test" forState:UIControlStateNormal];
	[inputVertifyBtn setBackgroundColor:[UIColor greenColor]];
	[inputVertifyBtn addTarget:self action:@selector(addinputVertifyView) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:inputVertifyBtn];
	
}
- (void)addinputVertifyView{
	//输入框
	InputVertifyView *inputView = [[InputVertifyView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 210)];
	inputView.layer.borderColor = [UIColor redColor].CGColor;
	inputView.layer.borderWidth = 1.0;
	inputView.clickSearch = ^(NSString *string){
		
		
		NSLog(@"查询数字:%@",string);
		
	};
	
	
	[self.view addSubview:inputView];
}
-(void)showAlert:(id)sender
{
	ZSDPaymentView *payment = [[ZSDPaymentView alloc]init];
	payment.title = @"支付密码标题";
	payment.goodsName = @"商品名称";
	payment.amount = 20.00f;
	
	[payment show];
}


/////
- (void)addView {
	
	NSArray *arr = @[@"普通，下划线 分割线",
					 @"普通，下划线",
					 @"密码",
					 @"密码，分割线"];
	for (NSInteger i = 0; i < arr.count; i ++) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150 + 80 * i, self.view.frame.size.width, 20)];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = arr[i];
		[self.view addSubview:label];
		
		CodeView *v = [[CodeView alloc] initWithFrame:CGRectMake(0, 170 + 80 * i, self.view.frame.size.width - 10, 60)
												  num:6
											lineColor:[UIColor blackColor]
											 textFont:50];
		
		switch (i) {
			case 0:
			{
				//                //下划线
				//                v.hasUnderLine = YES;
				//分割线
				v.hasSpaceLine = YES;
				//输入之后置空
				v.emptyEditEnd = YES;
				v.underLineAnimation = YES;
				//输入风格
				v.codeType = CodeViewTypeCustom;
			}
				break;
			case 1:
			{
				//下划线
				v.hasUnderLine = YES;
				//分割线
				v.hasSpaceLine = NO;
				
				//输入风格
				v.codeType = CodeViewTypeCustom;
			}
				break;
			case 2:
			{
				//下划线
				v.hasUnderLine = NO;
				//分割线
				v.hasSpaceLine = NO;
				
				//输入风格
				v.codeType = CodeViewTypeSecret;
			}
				break;
			case 3:
			{
				//下划线
				v.hasUnderLine = NO;
				//分割线
				v.hasSpaceLine = YES;
				
				//输入风格
				v.codeType = CodeViewTypeSecret;
			}
				break;
			default:
				break;
		}
		
		
		v.EndEditBlcok = ^(NSString *str) {
			NSLog(@"%@",str);
		};
		[self.view addSubview:v];
	}
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
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
