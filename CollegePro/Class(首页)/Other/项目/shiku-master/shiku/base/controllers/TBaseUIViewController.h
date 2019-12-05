//
//  TBaseUIViewController.h
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyViewController.h"
#import <XZFramework/MBProgressHUD.h>
/**
 *  UIViewController基类，所有Controller都继承此类
 */

@interface TBaseUIViewController : UIViewController
{
    CGSize screenSize;//设备显示屏大小
    BOOL ISIOS7PLUS;//系统是否为IOS7以上
    BOOL ISIPHONE6;//是否为iPhone6
    EmptyViewController *ec;
    MBProgressHUD *progressbar;//等待菊花
}
/**
 *  导航条上的white字体的返回按钮
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem*)leftBarBtnItem;
/**
 *  导航条上的黑色字体的返回按钮
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem *)tbarBackButton;
/**
 *  导航条上的白色字体的返回按钮
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem *)tbarBackButtonWhite;
/**
 *  导航条上可以自定义按钮图标的按钮，带action
 *
 *  @param text    图标所代表的Unicode编码
 *  @param selctor 触发的事件
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem *)tBarIconButtonItem:(NSString *)text action:(SEL)selctor;
/**
 *  导航条上可以自定义文字的按钮，带action
 *
 *  @param text    文字
 *  @param selctor 触发的事件
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem *)tBarButtonItem:(NSString *)text action:(SEL)selctor;

/**
 *  导航条上带搜索栏的控件
 *
 *  @param width                搜索栏宽度
 *  @param height               高度
 *  @param becomeFirstResponder
 *  @param fun                  触发的函数
 *  @param fdelegate            textFieldDelegate
 *
 *  @return UIView
 */
-(UIView *)tToolbarSearchField:(CGFloat)width withheight:(CGFloat)height isbecomeFirstResponder:(BOOL)becomeFirstResponder action:(SEL)fun textFieldDelegate:(id<UITextFieldDelegate>)fdelegate;
-(UIToolbar*)createToolbar;
/**
 *  显示一个新的页面
 *
 *  @param controller
 */
-(void)showNavigationView:(UIViewController *)controller;
/**
 *  显示一个新的页面，且导航条的背景色是主色调的颜色
 *
 *  @param controller
 */

-(void)showNavigationViewMainColor:(UIViewController *)controller;
/**
 * 返回不带导航栏的控制器
 */
-(void)showalphaNavigateControl:(UIViewController *)controller;

/**
 *  返回按钮
 */
-(void)goBack;
/**
 *  给UIView添加事件响应
 *
 *  @param view <#view description#>
 *  @param fun  <#fun description#>
 */
- (void)goSBack;
-(void)addListener:(UIView *)view action:(SEL)fun;
/**
 *  接口回调函数，比如更新后需要显示  更新成功，直接调用这个函数即可
 *
 *  @param text 要显示的信息
 */
- (void(^)(RACTuple *))didUpdate:(NSString *)text;
/**
 *  接口回调函数，比如更新地址信息后需要刷新列表
 *
 *  @param text
 *  @param tableview 
 */
- (void(^)(RACTuple *))didUpdate:(NSString *)text withTableView:(UITableView *)tableview;
/**
 *  显示分享界面
 *
 *  @param goods 商品对象
 */
-(void)showSharedView:(GOODS *)goods goodsID:(NSString *)goodsid couponCode:(NSString *)couponstr goodstitle:(NSString *)titleStr goodsinfor:(NSString *)infoStr imgUrl:(NSString *)urlImage shareUrl:(NSString *)shareurlStr;

/**
 *  验证手机号
 *
 *  @param mobileNum 手机号码
 *
 *  @return 如果是正确的手机号返回YES
 */
- (BOOL)validateMobile:(NSString *)mobileNum;
/**
 * 加载菊花
 *
 */

-(void)Showprogress;

/**
 * Loding..提示
 *
 */
-(void)ShowHDImgView:(NSString *)Title;

/**
 * Loding..hide
 *
 */
- (void)hideHUDView;

@end
