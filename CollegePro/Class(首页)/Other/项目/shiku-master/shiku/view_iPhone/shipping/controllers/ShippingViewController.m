//
//  WebHtmlViewController.m
//  btc
//
//  Created by txj on 15/4/29.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "ShippingViewController.h"
//#import <XZFramework/WebViewJavascriptBridge.h>

@interface ShippingViewController ()
//@property WebViewJavascriptBridge* bridge;
@end

@implementation ShippingViewController

-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url
{
    self=[super init];
  
    if (self) {
        self.title=stitle;
        strurl=url;
        mIsPopController=NO;
    }
  
    return self;
}
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url popController:(BOOL)isPopController andAnorder:(ORDER *)anOrder
{
    self=[super init];
    
    if (self) {
        self.title=stitle;
        strurl=url;
        mIsPopController=isPopController;
       
        manOrder=anOrder;
    }
    
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if (_bridge) { return; }
    
    self.navigationItem.leftBarButtonItem = [self tbarBackButton];
    //self.title=title;
    NSURL *url =[NSURL URLWithString:strurl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    self.webview.delegate=self;
    self.webview.scalesPageToFit = NO;
    [self.webview loadRequest:request];
    self.shippingContainer.backgroundColor=MAIN_COLOR;
    if ([manOrder.shipping_item.shipping_name isEqualToString:@""]) {
        self.shippingName.text=@"暂无物流信息";
        self.shippingCode.text=@"";
    }
    else{
    self.shippingName.text=manOrder.shipping_item.shipping_name;
    self.shippingCode.text= [NSString stringWithFormat:@"运单编号:%@",manOrder.shipping_item.shipping_sn];
    }
//
//
//    [WebViewJavascriptBridge enableLogging];
//    
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        responseCallback(@"Response for message from ObjC");
//    }];
//    
//    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"testObjcCallback called: %@", data);
//        responseCallback(@"Response from testObjcCallback");
//    }];
//    
//    [_bridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
//        NSLog(@"objc got response! %@", responseData);
//    }];
//    
//    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
//    
//    [_bridge send:@"A string sent from ObjC after Webview has loaded."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self Showprogress];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUDView];
    [self.indicator removeFromSuperview];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{   [self hideHUDView];
    [self.view showHUD:@"网络不给力，请稍后再试" afterDelay:1];
}
-(void)goBack
{
    if (!mIsPopController) {
        [super goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
