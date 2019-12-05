//
//  HomeWebViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/8/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"
@interface HomeWebViewController : TBaseUIViewController<UIWebViewDelegate,UITextFieldDelegate>{
    NSString *title;//标题
    NSString *strurl;//链接
    BOOL mIsPopController;//是否重新弹出一个界面
}
@property WebViewJavascriptBridge* bridge;
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url;
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url popController:(BOOL)isPopController;
@end
