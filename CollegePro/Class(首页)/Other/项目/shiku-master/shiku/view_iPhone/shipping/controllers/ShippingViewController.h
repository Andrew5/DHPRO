//
//  WebHtmlViewController.h
//  btc
//
//  Created by txj on 15/4/29.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  html页面
 */

@interface ShippingViewController : TBaseUIViewController<UIWebViewDelegate>
{
    NSString *title;//标题
    NSString *strurl;//链接
    BOOL mIsPopController;//是否重新弹出一个界面
    ORDER *manOrder;
}
@property (weak, nonatomic) IBOutlet UIView *shippingContainer;
@property (weak, nonatomic) IBOutlet UILabel *shippingName;
@property (weak, nonatomic) IBOutlet UILabel *shippingCode;


@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url;
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url popController:(BOOL)isPopController andAnorder:(ORDER *)anOrder;
@end
