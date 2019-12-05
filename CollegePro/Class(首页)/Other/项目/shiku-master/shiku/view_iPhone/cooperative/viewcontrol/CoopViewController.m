//
//  CoopViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/9/10.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CoopViewController.h"
#import "ConnperativeMemberViewController.h"
#import "HomeViewControllernew.h"
@interface CoopViewController ()
{
    NSString *codeStr;
}
@end

@implementation CoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"合作社";
    //    _webview.delegate = self;
    
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    _vbackground.backgroundColor = RGBCOLORV(0X7A9C5C);
    GoodsDetailShareViewCell*cell = [GoodsDetailShareViewCell new];
    cell.delegate = self;
    [_memberBtn addTarget:self action:@selector(memberManager) forControlEvents:(UIControlEventTouchUpInside)];
    [self loadData];

}
-(void)loadData{
    //社长 //310467
    App *app = [App shared];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%@",app.currentUser.token]forKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/cooperation/getMoney",url_share];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"money"] isEqualToString:@""]) {
            _labelWealth.text = responseObject[@"money"];
            codeStr = responseObject[@"data"][@"coupon_code"];
            return ;
        }
        _labelWealth.text = @"0.00";
    }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (_bridge) { return; }

    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
    }];
    //进入农场
    [_bridge registerHandler:@"enterFarmer" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadaFarmerData:data[@"farmerid"]];
    }];
    //进入发福利
    [_bridge registerHandler:@"enterWelfare" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self showSharedView:nil goodsID:data[@"goodsid"] couponCode:_tokenStr goodstitle:data[@"goodstitle"] goodsinfor:data[@"goodsinfor"] imgUrl:data[@"imgUrl"] shareUrl:nil];
    }];
    
    
    [_bridge registerHandler:@"enterGoods" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadGoodsData:data[@"goodsid"]];

    }];

    
    [self loadExamplePage:_webview];
    
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
    //分享  发福利
    NSString *url = [NSString stringWithFormat:@"http://www.shiku.com/index.php/?g=webview&m=welfare&a=index"];;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}
-(void)memberManager{
    ConnperativeMemberViewController *uc = [ConnperativeMemberViewController new];
    uc.scoiety = _tokenStr;
    uc.money = _labelWealth.text;
    [self.navigationController pushViewController:uc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
