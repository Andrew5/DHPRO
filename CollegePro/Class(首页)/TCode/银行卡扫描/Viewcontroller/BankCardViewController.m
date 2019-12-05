//
//  BankCardViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/12/19.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "BankCardViewController.h"
#import "CardIO.h"

//
#import "SFNetWorkManager.h"
#import "NetWork.h"

#import "SDWebImage/UIButton+WebCache.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BankCardViewController ()<CardIOPaymentViewControllerDelegate>
@property (strong, nonatomic) UILabel *infoLabel;

@end

@implementation BankCardViewController
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[CardIOUtilities preload];
}
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	
	NSLog(@"Scan succeeded with info: %@", info);
	// cardNumber 是扫描的银行卡号，显示的是完整号码，而 redactedCardNumber 只显示银行卡后四位，前面的用 * 代替了，返回的银行卡号都没有空格
	NSString *redactedCardNumber = info.cardNumber;     // 卡号
	NSUInteger expiryMonth = info.expiryMonth;          // 月
	NSUInteger expiryYear = info.expiryYear;            // 年
	NSString *cvv = info.cvv;                           // CVV 码
	
	// 显示扫描结果
	NSString *msg = [NSString stringWithFormat:@"Number: %@\n\n expiry: %02lu/%lu\n\n cvv: %@", [self dealCardNumber:redactedCardNumber], (unsigned long)expiryMonth, expiryYear, cvv];
	[[[UIAlertView alloc] initWithTitle:@"Received card info" message:msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
	
	
	// Do whatever needs to be done to deliver the purchased items.
	[paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
	NSLog(@"User cancelled scan");
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIButton *_btn_card = [UIButton buttonWithType:UIButtonTypeCustom];
	[_btn_card setTitle:@"扫描" forState:UIControlStateNormal];
	_btn_card.frame = CGRectMake(self.view.centerX, 64, 60, 30);
	[_btn_card addTarget:self action:@selector(scanCardClicked:) forControlEvents:(UIControlEventTouchUpInside)];
	[_btn_card setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[self.view addSubview:_btn_card];
	
	_infoLabel = [[UILabel alloc]init];
	_infoLabel.frame = CGRectMake(15, _btn_card.bottom+10, self.view.width-30, 80);
	[self.view addSubview:_infoLabel];
	
	
	UIButton *_btn_XLCard = [UIButton buttonWithType:UIButtonTypeCustom];
	[_btn_XLCard setTitle:@"XL扫描" forState:UIControlStateNormal];
	[_btn_XLCard sd_setImageWithURL:[NSURL URLWithString:[@"https://apimg.alipay.com/combo.png?d=cashier&t=" stringByAppendingString:@"HDBANK"]] forState:0];
	_btn_XLCard.frame = CGRectMake(self.view.centerX, 130, 60, 40);
	_btn_XLCard.layer.borderColor = [UIColor redColor].CGColor;
	_btn_XLCard.layer.borderWidth = 1.0;
	[_btn_XLCard addTarget:self action:@selector(scanXLCardClicked:) forControlEvents:(UIControlEventTouchUpInside)];
	[_btn_XLCard setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[self.view addSubview:_btn_XLCard];

}
- (void)scanXLCardClicked:(id)sender {
//	[self.navigationController pushViewController:[XLBankScanViewController new] animated:YES];
//	[NetWork GETWithUrl:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=6258081653531836&cardBinCheck=true" parameters:nil view:self.view ifMBP:YES success:^(id responseObject) {
//		NSLog(@"responseObject %@",responseObject);
//	} fail:^{
//		NSLog(@"");
//	}];
	[SFNetWorkManager requestWithType:0 withUrlString:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8" withParaments:@{@"cardNo":@"6258081653531836",@"cardBinCheck":@"true"} withSuccessBlock:^(NSDictionary *object) {
		NSLog(@"responseObject %@",object);
	} withFailureBlock:^(NSError *error) {
		NSLog(@"responseObject %@",error.description);
	} progress:^(float progress) {
		
	}];

}
#pragma mark - User Actions

- (void)scanCardClicked:(id)sender {
	CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
	scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
	[self presentViewController:scanViewController animated:YES completion:nil];
}

// 对银行卡号进行每隔四位加空格处理，自定义方法
- (NSString *)dealCardNumber:(NSString *)cardNumber {
	
	NSString *strTem = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *strTem2 = @"";
	
	if (strTem.length % 4 == 0) {
		
		NSUInteger count = strTem.length / 4;
		for (int i = 0; i < count; i++) {
			NSString *str = [strTem substringWithRange:NSMakeRange(i * 4, 4)];
			strTem2 = [strTem2 stringByAppendingString:[NSString stringWithFormat:@"%@ ", str]];
		}
		
	} else {
		
		NSUInteger count = strTem.length / 4;
		for (int j = 0; j <= count; j++) {
			
			if (j == count) {
				NSString *str = [strTem substringWithRange:NSMakeRange(j * 4, strTem.length % 4)];
				strTem2 = [strTem2 stringByAppendingString:[NSString stringWithFormat:@"%@ ", str]];
			} else {
				NSString *str = [strTem substringWithRange:NSMakeRange(j * 4, 4)];
				strTem2 = [strTem2 stringByAppendingString:[NSString stringWithFormat:@"%@ ", str]];
			}
		}
	}
	
	return strTem2;
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
