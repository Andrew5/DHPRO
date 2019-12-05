//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by bosheng on 15/10/20.
//  Copyright © 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class GKHScanQCodeViewController;
@protocol QRScanViewDelegate <NSObject>
- (void)GKHScanQCodeViewController:(GKHScanQCodeViewController *)lhScanQCodeViewController readerScanResult:(NSString *)result;//二维码扫描的字符串
@end
@interface GKHScanQCodeViewController : BaseViewController
@property (weak,nonatomic)  id<QRScanViewDelegate> delegate;

//二维码扫描使用方法
//GKHScanQCodeViewController * sqVC = [[GKHScanQCodeViewController alloc]init];
//sqVC.delegate=self;
//UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
//[self presentViewController:nVC animated:YES completion:nil];

/**
 *  将一个二维码图片转换成string对象
 *
 *  @param QRimage 二维码图片
 *
 *  @return NSString 字符串
 */
+(NSString *)QRStringByimage:(UIImage *)QRimage;
@end
