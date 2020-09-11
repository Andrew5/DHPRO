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
#import "KeyBoardVView.h"

@interface PayViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *titleTextField;
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

    
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 10, 48)];
    titleTextField.layer.borderColor = [UIColor greenColor].CGColor;
    titleTextField.layer.borderWidth = 1.0;
    titleTextField.placeholder = @"请输入公告标题(12个字符)";
    [titleTextField setDelegate:self];
    titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    titleTextField.returnKeyType = UIReturnKeyDone;
    [titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [self.view addSubview:titleTextField];
    self.titleTextField = titleTextField;
        
    KeyBoardVView * KBView = [[KeyBoardVView alloc]initWithFrame:CGRectMake(0, 50 , self.view.frame.size.width, 217)];
    KBView.inputSource = self.titleTextField;
    self.titleTextField.inputAccessoryView = KBView;

}
- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
//        if (titleTextField.text.length >= 12) {
//            titleTextField.text = [titleTextField.text substringToIndex:12];
//        }
    } else {
        // 有高亮选择的字 不做任何操作
    }
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
    if (![noEmojiStr isEqualToString:textField.text]) {
        textField.text = noEmojiStr;
    }
}
- (void)keyboardWasShown:(NSNotification *)noti{
    NSDictionary *dict = [noti userInfo];
    NSValue *valueBegin = [dict objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardBeginSize = [valueBegin CGRectValue].size;
    NSValue *valueEnd = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardEndSize = [valueEnd CGRectValue].size;

    NSLog(@"keyboardSize %f\n keyboardEndSize %f",keyboardBeginSize.height,keyboardEndSize.height);
    
    NSNumber *duration = [dict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dict objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
    }];
}
#pragma mark - TextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 20) {
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    if (textField.text.length < 2) {
        // 提示用户，名称长度至少为2位
        [SVProgressHUD showErrorWithStatus:@"名称长度至少为2位"];
        return NO;
    }
    // 设置用户名
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
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
-(void)showAlert:(id)sender{
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
