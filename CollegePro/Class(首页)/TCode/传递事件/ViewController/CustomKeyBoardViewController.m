//
//  CustomKeyBoardViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/5/3.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "CustomKeyBoardViewController.h"

@interface CustomKeyBoardViewController ()<UITextFieldDelegate>

@end

@implementation CustomKeyBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//	UITextField *textField_Input = [[UITextField alloc]init];
	UITextField * textField_Input = [[UITextField alloc] initWithFrame:CGRectMake(100, DH_DeviceHeight-50, 200, 60)];
	textField_Input.delegate = self;
	textField_Input.placeholder=@"显示当选地点";
	textField_Input.returnKeyType = UIReturnKeySearch; //设置按键类型
	textField_Input.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
	textField_Input.textColor = [UIColor redColor];
	textField_Input.textAlignment = NSTextAlignmentLeft;
	textField_Input.layer.borderColor = [UIColor redColor].CGColor;
	textField_Input.layer.borderWidth = 1.0;
	[textField_Input setBorderStyle:UITextBorderStyleRoundedRect];
	[textField_Input setClearButtonMode:UITextFieldViewModeAlways];//设置清除按钮模式
	//设置左视图的坐标没有意义
	UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
	leftLabel.text = @"账号:";
	textField_Input.leftView = leftLabel;
	[textField_Input setLeftViewMode:UITextFieldViewModeAlways];
	textField_Input.clearsOnBeginEditing = YES;
	// 设置了占位文字内容以后, 才能设置占位文字的颜色
	[textField_Input setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[self.view addSubview:textField_Input];
	
//	textField_Input.sd_layout
//	.leftSpaceToView(self.view, 20)
//	.topEqualToView(self.view).offset(100)
////	.bottomSpaceToView(self.view, 100)
//	.heightIs(50)
//	.rightSpaceToView(self.view, 20);

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	NSLog(@"开始编辑");
	
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	
	NSLog(@"已经停止编辑");
	
}
- (void)test{
	NSDictionary *params = @{@"json":@"RepairListForApp",@"RepaireStatus":@"0,1",@"BillTypeId":[NSNumber numberWithInteger:1],@"CompanyId":@"-9057"};
	
	[[ECHttpRequestServer sharedClient] GetZT:@"WebService/jsonInterface.ashx" parameters:params success:^(id  _Nonnull responseObject) {

		if ([responseObject[@"result"] boolValue] == YES)
		{
			NSLog(@"显示 %@",responseObject[@"RepairList"]);
		}else{
            NSLog(@"完成 %@",responseObject[@"RepairList"]);
//            [self showHint:responseObject[@"RepairList"]];
		}
		
	} failure:^(NSError * _Nonnull error) {
		
		//        table.hidden = YES;
		//        [self.view addSubview:self.defaultLabel];
	}];
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
