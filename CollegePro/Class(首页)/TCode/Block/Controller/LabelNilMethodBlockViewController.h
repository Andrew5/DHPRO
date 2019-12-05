//
//  LabelNilMethodBlockViewController.h
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyReturnTextBlock)(NSString *showText);
typedef void (^receiveNoti)(NSString *showText);
@interface LabelNilMethodBlockViewController : BaseViewController
extern NSString *lhString;//这里由于带有extern所以会被认为是全局变量
@property (nonatomic, copy) MyReturnTextBlock myReturnTextBlock;
@property(nonatomic,strong) NSDictionary *communicationMessage;
@property(nonatomic,copy) NSString *nameP;
//RTC回调
@property (nonatomic, copy) receiveNoti reception;
+ (void)numberInfor:(void(^)(NSString * infor))inforBlock;
+ (BOOL)isWhiteSkinColor;
+ (BOOL)isWXAppInstalled;
- (NSString *)textFunction:(NSString *)str;
- (void)textValueFunction:(void(^)(NSString * infor))inforBlock;

+ (void)loadDetailCallBack:(NSString *)name callBack:(void(^)(NSString* str))FinishCallBack;
// 防止多次调用
- (void)getShouldPrevent:(int)seconds;
@end
