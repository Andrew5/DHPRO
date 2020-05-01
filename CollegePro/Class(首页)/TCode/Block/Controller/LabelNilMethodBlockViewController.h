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
//类方法 必须使用类调用，在方法里面不能调用属性，存储在元类结构体里面的methodLists里面
+ (void)numberInfor:(void(^)(NSString * infor))inforBlock;
+ (BOOL)isWhiteSkinColor;
+ (BOOL)isWXAppInstalled;
+ (void)loadDetailCallBack:(NSString *)name callBack:(void(^)(NSString* str))FinishCallBack;
//实例方法 必须使用实例对象调用，可以在实例方法里面使用属性，实例方法也必须调用实例方法。存储在类结构体里面的methodLists里面
- (NSString *)textFunction:(NSString *)str;
- (void)textValueFunction:(void(^)(NSString * infor))inforBlock;
// 防止多次调用
- (void)getShouldPrevent:(int)seconds;
@end
