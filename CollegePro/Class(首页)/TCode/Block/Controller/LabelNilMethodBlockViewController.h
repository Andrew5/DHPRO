//
//  LabelNilMethodBlockViewController.h
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//


typedef NS_ENUM (NSUInteger,PAYType) {
    PAYTypeSuccess = 0,
    PAYTypeFail = 1,
    PAYTypePaying = 2,
    PAYTypeCancel = 3,
    PAYTypeErrorparams = 5,
};
static NSString * _Nonnull PAYTypeStringMap[] = {
    [PAYTypeSuccess] = @"支付成功",
    [PAYTypeFail] = @"支付失败",
    [PAYTypePaying] = @"支付中",
    [PAYTypeCancel] = @"支付取消",
    [PAYTypeErrorparams] = @"参数错误"
};

#import <UIKit/UIKit.h>
typedef void (^MyReturnTextBlock)(NSString *showText);
typedef void (^receiveNoti)(NSString * _Nullable showText);
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
- (void)pay:(NSDictionary*)param complete:(void(^)(enum PAYType resultCode,NSString* resultMessage)) completionHandler;

@end
