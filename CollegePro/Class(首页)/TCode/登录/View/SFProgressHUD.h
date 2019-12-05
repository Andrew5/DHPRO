//
//  SFProgressHUD.h
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/11.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
typedef NS_ENUM(NSUInteger,SFProgressMode)
{
    
    SFProgressModeOnlyText = 10,           //文字
    SFProgressModeLoading,              //加载菊花
    SFProgressModeCircleLoading,         //加载圆形
    SFProgressModeSuccess               //成功
};

@interface SFProgressHUD : NSObject
/*===============================   属性   ================================================*/

@property (nonatomic,strong) MBProgressHUD  *hud;


/*===============================   方法   ================================================*/

+(instancetype)shareinstance;

//显示
+(void)show:(NSString *)msg inView:(UIView *)view mode:(SFProgressMode *)myMode;

//隐藏
+(void)hide;

//只显示文字
+(void)showOnlyText:(NSString *)msg inView:(UIView *)view;

//显示进度
+(void)showProgress:(NSString *)msg inView:(UIView *)view;

//显示成功提示
+(void)showSuccess:(NSString *)msg inview:(UIView *)view;

//显示提示（1秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view;

//显示提示（N秒后消失）
+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;

//在最上层显示
+(void)showMsgWithoutView:(NSString *)msg;

@end
