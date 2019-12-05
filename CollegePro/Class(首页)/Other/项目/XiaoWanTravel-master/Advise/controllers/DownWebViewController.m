//
//  DownWebViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/8/1.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DownWebViewController.h"
static int pageNum=0;
@interface DownWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation DownWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWeb];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"login_close_icon@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"上一页" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
    //self.navigationItem.backBarButtonItem = back;
    self.navigationItem.leftBarButtonItems = @[left, back];
    
    if (self.dataArray.count!=0) {
        if (pageNum<self.dataArray.count-1) {
            self.navigationItem.rightBarButtonItem = right;
        }
    }
}
-(void)back
{
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)last{
    if (pageNum==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        pageNum--;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)next{
    pageNum++;
    DownWebViewController* down=[[DownWebViewController alloc]init];
    down.url=self.url;
    [self.navigationController pushViewController:down animated:YES];
}



-(void)createWeb
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSString* filePath=[NSString stringWithFormat:@"%@/%@/menu.json",NSHomeDirectory(),self.url];
    NSData* data=[NSData dataWithContentsOfFile:filePath];
    self.dataArray=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //创建webView
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+48)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;

    NSString* htmlPath=[NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),self.url,self.dataArray[pageNum][@"file"]];
    NSURL *url = [NSURL URLWithString:htmlPath];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    //self.navigationItem.title=[NSString stringWithFormat:@"%@ %d/%lu",self.dataArray[pageNum][@"title"],pageNum+1,(unsigned long)self.dataArray.count];
}
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
