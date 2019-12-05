//
//  HealthViewController.m
//  Test
//
//  Created by Uwaysoft on 2018/8/13.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "HealthViewController.h"
#import "HealthManager.h"
@interface HealthViewController ()

@end

@implementation HealthViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	
	UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
	contentLabel.numberOfLines = 0;
	contentLabel.textAlignment = NSTextAlignmentCenter;
	contentLabel.font = [UIFont systemFontOfSize:16];
	contentLabel.textColor = [UIColor darkGrayColor];
	[self.view addSubview:contentLabel];
	
	UILabel *contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, contentLabel.bottom_sd+10, self.view.frame.size.width, 30)];
	contentLabel1.numberOfLines = 0;
	contentLabel1.textAlignment = NSTextAlignmentCenter;
	contentLabel1.font = [UIFont systemFontOfSize:16];
	contentLabel1.textColor = [UIColor redColor];
	[self.view addSubview:contentLabel1];
	
	UILabel *contentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, contentLabel1.bottom_sd+10, self.view.frame.size.width, 30)];
	contentLabel2.numberOfLines = 0;
	contentLabel2.textAlignment = NSTextAlignmentCenter;
	contentLabel2.font = [UIFont systemFontOfSize:16];
	contentLabel2.textColor = [UIColor blueColor];
	[self.view addSubview:contentLabel2];
	
	
	
	HealthManager *manage = [HealthManager shareInstance];
	[manage authorizeHealthKit:^(BOOL success, NSError *error) {
		
		if (success) {
			NSLog(@"success");
			[manage getDistance:^(double value, NSError *error) {
				NSLog(@"2count-->%.2f", value);
				NSLog(@"2error-->%@", error.localizedDescription);
				dispatch_async(dispatch_get_main_queue(), ^{
					contentLabel2.text = [NSString stringWithFormat:@"当天行走距离 = %.2f",value];
				});
				
			}];
			
			
			
			[manage getKilocalorieUnit:[HealthManager predicateForSamplesToday] quantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned] completionHandler:^(double value, NSError *error) {
				if(error)
				{
					//DebugLog(@"error = %@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
				}
				else
				{
					CGFloat ka = value;
					dispatch_async(dispatch_get_main_queue(), ^{
						contentLabel1.text = [NSString stringWithFormat:@"获取到的卡路里  = %.2lf",ka];
					});
					
				}
			}];
			
			[manage getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
				
				dispatch_async(dispatch_get_main_queue(), ^{
				contentLabel.text = [NSString stringWithFormat:@"当天行走步数 = %.0f",value];
				});
				
			}];
			
		}
		else {
			NSLog(@"fail");
		}
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
