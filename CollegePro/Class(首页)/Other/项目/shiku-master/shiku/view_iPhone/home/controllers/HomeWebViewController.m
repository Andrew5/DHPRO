//
//  HomeWebViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/8/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeWebViewController.h"
#import "SearchViewController.h"
#import "HomeViewControllernew.h"
#import "AppDelegate.h"
@interface HomeWebViewController ()

@end

@implementation HomeWebViewController

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
-(instancetype)initWithTitle:(NSString *)stitle withUrl:(NSString *)url popController:(BOOL)isPopController
{
    self=[super init];
    
    if (self) {
        self.title=stitle;
        strurl=url;
        mIsPopController=isPopController;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[self tbarBackButtonWhite];
    
    //添加导航搜索
    UIView *searchFieldView=[self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-115 withheight:20
                               isbecomeFirstResponder:false action:@selector(searchFieldTouched) textFieldDelegate:self];
    
    self.navigationItem.titleView = searchFieldView;
    
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = NO;
    
    UDNavigationController *navi = (UDNavigationController*)self.navigationController;
    navi.alphaView.hidden = NO;
    self.navigationController.navigationBarHidden = NO;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = YES;
    app.viewController.navigationController.navigationBarHidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    UDNavigationController *navi = (UDNavigationController*)self.navigationController;
    navi.alphaView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    if (_bridge) { return; }
   
    [self Showprogress];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@",responseCallback);

    }];
    
    [_bridge registerHandler:@"enterFarmer" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadaFarmerData:data[@"farmerid"]];
    }];
    
    
    [_bridge registerHandler:@"enterGoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadGoodsData:data[@"goodsid"]];
    }];
    
    [_bridge registerHandler:@"enterWelfare" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadaFarmerData:data[@"goodsid"]];
    }];
    
    
    
    [_bridge registerHandler:@"finishActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self callbackViewController];
    }];
    
    [_bridge registerHandler:@"shareSearchFoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self showSharedView:nil goodsID:nil couponCode:nil goodstitle:data[@"shareTitle"] goodsinfor:data[@"shareInfo"] imgUrl:data[@"imgurl"] shareUrl:data[@"shareUrl"]];
    }];

    [self hideHUDView];

    [self loadExamplePage:webView];


}

-(void)callbackViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadGoodsData:(NSString*)goosdID{
    GoodsDetailViewController *personInfo = [[GoodsDetailViewController alloc]init];

    id result;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    result=[f numberFromString:goosdID];
    if(!(result))
    {
        result=goosdID;
    }
    personInfo.goods_id = result;
    [self.navigationController pushViewController:personInfo animated:YES];

}
-(void)loadaFarmerData:(NSString *)farmerID{
    HomeViewControllernew *info = [[HomeViewControllernew alloc]init];
    info.midStr = farmerID;
    [self.navigationController pushViewController:info animated:YES];

}
- (void)loadExamplePage:(UIWebView*)webView {
    NSString *url = @"http://172.27.35.1:63340/explore/explore/index.html";
//    NSString *url =@"http://www.shiku.com/webview/explore/index.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];

}
-(void)searchFieldTouched{
    SearchViewController *sc=[SearchViewController new];
    [self.navigationController pushViewController:sc animated:NO];
    
    //    GoodsListViewController *gl=[GoodsListViewController new];
    //    [self showNavigationViewMainColor:gl];
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
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self Showprogress];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHUDView];
}
-(void)loadWebViewData:(UIWebView*)webView{
    //webView可以是UIWebView或WKWebView
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponseCallback responseCallback)
    {
        NSLog(@"Received message from javascript: %@", data);
        responseCallback(@"Right back atcha");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
