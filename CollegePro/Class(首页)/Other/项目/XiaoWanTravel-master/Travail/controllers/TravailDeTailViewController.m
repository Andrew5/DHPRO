//
//  TravailDeTailViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "TravailDeTailViewController.h"
#import "AFNetworking.h"
#import "PrefixHeader.pch"
@interface TravailDeTailViewController ()
{
    UIWebView *_webView;
}
@end

@implementation TravailDeTailViewController
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWeb];
}
-(void)createData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString* URL=[NSString stringWithFormat:DISCOUNTDETAIL1,self.ID,DISCOUNTDETAIL2];
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = [rootDic objectForKey:@"data"];
        NSString *url = [dic objectForKey:@"app_url"];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
-(void)createWeb
{
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    if (self.ID ==nil) {
        [_webView loadRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url]]];
    }else{
        [self createData];
    }
    [self.view addSubview:_webView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 50, 50);
    [button setImage:[UIImage imageNamed:@"login_close_icon@3x"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];

    [_webView addSubview:button];
}
-(void)btnLeftClick
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden=NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
