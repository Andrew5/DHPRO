//
//  WKWebViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/4/6.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "WKWebViewController.h"
#import "BaseTabBarViewController.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,NSURLSessionDelegate,NSURLSessionTaskDelegate>
@property (strong, nonatomic) WKWebView *WKView;
@property (strong, nonatomic) UIButton *toolBtn;

@end

@implementation WKWebViewController
- (instancetype)initWithHtml:(NSString *)html navTitle:(NSString *)title
{
    if (self = [super init]) {
        self.navTitle = title;
//        self.html = html;
    }
    return self;
}
- (instancetype)initWithUrl:(NSString *)url navTitle:(NSString *)title
{
    return [self initWithUrl:url navTitle:title type:0];
}
- (instancetype)initWithUrl:(NSString *)url navTitle:(NSString *)title type:(NSInteger)type {
    if (self = [super init]) {
//        self.type = type;
        self.navTitle = title;
///     初始化 webview -> 请求页面 -> 下载数据 -> 解析HTML -> 请求 js/css 资源 -> dom 渲染 -> 解析 JS 执行 -> JS 请求数据 -> 解析渲染 -> 下载渲染图片

//        self.url = url;
//        self.time = 0;
//        if (_type == 1) {
//            //倒计时
//            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self createUI];
    self.title = self.navTitle;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"icon_back_lessonDetail"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:left];
    
    self.navigationController.navigationBar.hidden = NO;

    BaseTabBarViewController *main = (BaseTabBarViewController *)self.tabBarController;
    main.visitorLabel.hidden = YES;

}

- (void)ReloadBtnClick{
    [self.WKView reload];

}
- (void)createUI{
//    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(ReloadBtnClick)];
    self.navigationItem.rightBarButtonItem = myButton;
    
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButtonView];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
//    [self.view addSubview:({
//        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [rightBtn.titleLabel setText:@"刷新"];
//        rightBtn.titleLabel.textColor = [UIColor blueColor];
//        rightBtn;
//    })];
    //! WKWebView
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    //JS调用OC 添加处理脚本
    [wkUController addScriptMessageHandler:self name:@"jsInvokeOCMethod"];///js打印事件
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.processPool = [[WKProcessPool alloc] init];
    // 设置偏好设置对象
    config.preferences = preference;
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    
    self.WKView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    // UI代理
    self.WKView.UIDelegate = self;
    // 导航代理
    self.WKView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    self.WKView.allowsBackForwardNavigationGestures = YES;
    self.WKView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.WKView.autoresizesSubviews = YES;
    [self.view addSubview:self.WKView];
     //注入js的代码，就相当于重写了js的printLog方法，在printLog方法中去调用原生方法
    // function 后面的方法名跟js代码中的方法名要一致
    //此处的printLog 可自己定义但是要跟上面的addScriptMessageHandler 的name保持一致
    NSString *printContent = @"function jsInvokeOCMethod() { window.webkit.messageHandlers.jsInvokeOCMethod.postMessage(null);}";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:printContent injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [self.WKView.configuration.userContentController addUserScript:userScript];
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    if (@available(iOS 11.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        self.WKView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.WKView.scrollView.contentInset = UIEdgeInsetsZero;
        self.WKView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"WKOCBridgeJS" withExtension:@"html"];
//    [self.WKView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        // Fallback on earlier versions
    }
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"WKOCBridgeJS.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    if (@available(iOS 9.0, *)) {
        [self.WKView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    } else {
        // Fallback on earlier versions
    }

//    NSURL *fileURL = [NSURL URLWithString:@"http://59.110.243.193:8080/xlby_wx/enjoyment/appCoupon?nsukey=yoKDJkj8%2BnO6kJuSgeuUsYjkn6TSCoC67Hy3JKp%2BQSar50yEpf3MhQQwqWRrWv%2FeymNQvyHifbbEsnSNVJzPxEO36iSLxAfZgZJYnmhnU6ScMlSkSnRBQUTR%2BEjUWtclKHMo9PP336SdifWEsUDFicGj9C1jT1fOQmQ3a6tqR9T9LJiRsEruIpqXw013C9kq9AOt5wd699CIyJcQeKkLZg%3D%3D"];
//    NSURL *fileURL = [NSURL URLWithString:@"https://paveldogreat.github.io/WebGL-Fluid-Simulation/"];//https://github.com/PavelDoGreat/
    //https://developer.nvidia.com/gpugems/gpugems/part-vi-beyond-triangles/chapter-38-fast-fluid-dynamics-simulation-gpu
//    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:fileURL];
//    [self.WKView loadRequest:downloadRequest];
    //WK用于正常加载
    //NSURLCache 实例化
    NSURLCache *cache = [NSURLCache sharedURLCache];
    /*
     //或者
     NSURL *url = [NSURL URLWithString:@"http://www.connect.com/login"];
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     request.HTTPMethod = @"POST";
     request.HTTPBody = [@"username=admin&pwd=12344321123456" dataUsingEncoding:NSUTF8StringEncoding];
     //使用全局的会话
     NSURLSession *session = [NSURLSession sharedSession];
     // 通过request初始化task
     NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
     }];
     [task resume];
     */
    NSURLRequest *request =  [NSURLRequest requestWithURL:fileURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:6];
//    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    //得到NSData 数据
    NSData *dataContent = [NSData dataWithContentsOfURL:fileURL];
    //得到相应
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:fileURL MIMEType:@"text/html" expectedContentLength:0 textEncodingName:@"UTF-8"];

    //得到CacheURLResponse
    NSCachedURLResponse *cacheResponse = [[NSCachedURLResponse alloc]initWithResponse:response data:dataContent];
    //URL缓存设置
    [cache setMemoryCapacity:25*1024*1024];
    [cache setDiskCapacity:100*1024*1024];
    [NSURLCache setSharedURLCache:cache];
    //进行存储
    [cache storeCachedResponse:cacheResponse forRequest:request];
    //缓存 在APP目录中，会在Caches目录下以Bundle Identifier为名创建缓存目录。缓存的资源图片，CSS、JS、html等都在这个目录下

    //Session配置
    //创建配置（决定要不要将数据和响应缓存在磁盘）
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    //生成任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    //创建的task是停止状态，需要我们去启动
    [task resume];
    //离线加载
//        NSCachedURLResponse  *current = [cache cachedResponseForRequest:request];
//        [self.WKView loadData:current.data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:self.request.URL];

    self.WKView.layer.borderColor = [UIColor greenColor].CGColor;
    self.WKView.layer.borderWidth = 1.0;
    //可返回的页面列表, 存储已打开过的网页
    //    WKBackForwardList * backForwardList = [self.WKView backForwardList];
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    //    [request addValue:[self readCurrentCookieWithDomain:@"http://www.baidu.com.cn"] forHTTPHeaderField:@"Cookie"];
    //    [self.WKView loadRequest:backForwardList];
    //    self.WKView.scrollView.scrollEnabled = NO;
    //    self.WKView.userInteractionEnabled = NO;
    self.WKView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,500);
    [self.WKView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    [self.WKView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    //圆形进度条
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    _HUD.mode = MBProgressHUDModeAnnularDeterminate;
//    _HUD.delegate = self;
//    _HUD.labelText = @"正在加载";
//    _HUD.labelColor = [UIColor blackColor];
//    _HUD.color = [UIColor blackColor];
//    [self.view addSubview:_HUD];
    //添加测试按钮
    [self.view addSubview:self.toolBtn];
}
//1.接收到服务器响应的时候调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSLog(@"接收响应");
    //必须告诉系统是否接收服务器返回的数据
    //默认是completionHandler(NSURLSessionResponseAllow)
    //可以再这边通过响应的statusCode来判断否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}
//2.接受到服务器返回数据的时候调用,可能被调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"接收到数据");
    //一般在这边进行数据的拼接，在方法3才将完整数据回调
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
//3.请求完成或者是失败的时候调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"请求完成或者是失败");
    //在这边进行完整数据的解析，回调
}
//4.将要缓存响应的时候调用（必须是默认会话模式，GET请求才可以）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler{
    //可以在这边更改是否缓存，默认的话是completionHandler(proposedResponse)
    //不想缓存的话可以设置completionHandler(nil)
    completionHandler(proposedResponse);
}
/*=========代理方式===========*/
//UploadTask继承自DataTask。因为UploadTask只不过在Http请求的时候，把数据放到Http Body中。所以，用UploadTask来做的事情，通常直接用DataTask也可以实现。
//NSURLSessionUploadTask通过request创建，在上传时指定文件源或数据源，可以用代理或Block指定任务完成后的回调代码。
//通过文件url来上传
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL;
////通过文件data来上传
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData;
////通过文件流来上传
//- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request;
///*=========Block方式===========*/
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
//- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

- (void)toolPage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.WKView evaluateJavaScript:@"ocToJs('loginSucceed', 'oc_tokenString')" completionHandler:^(id response, NSError *error) {
            NSLog(@"response: %@", response);
        }];
        
//        NSDictionary *parm = @{
//            @"platform" : @"2",
//            @"versionName" : @"1.5",
//            @"mobile" : @"18600294854",
//            @"userId" : @"240",
//            @"userToken" : @"JAVJNyWk52GM4cdw7Yedh/66dr8ksMlL3BI8Vwt0MUlEI9no8NG/b6qiWWJdkPzg3FRlo89AiRNF+kOVn6FspQ=="
//        };
//        NSError *parseError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parm options:NSJSONWritingPrettyPrinted error:&parseError];
//        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSString *jsMethod = [NSString stringWithFormat:@"%@('%@','%@')",@"ocToJs",@"loginSucceed",json];
//        [self.WKView evaluateJavaScript:jsMethod completionHandler:^(id response, NSError *error) {
//            NSLog(@"response: %@", response);
//        }];

    });
}
- (UIButton *)toolBtn{
    if (_toolBtn == nil)
    {
        _toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toolBtn.frame = CGRectMake(100, 0, 100, 25);
        [_toolBtn setTitle:@"JS方法注入" forState:(UIControlStateNormal)];
        [_toolBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _toolBtn.layer.borderColor = [UIColor greenColor].CGColor;
        _toolBtn.layer.borderWidth = 1.0;
        [_toolBtn addTarget:self action:@selector(toolPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolBtn;
}
- (void)setAllowsInlineMediaPlayback:(BOOL)yOrN {
    
    self.WKView.configuration.allowsInlineMediaPlayback = YES;
}
- (BOOL)allowsInlineMediaPlayback {
    return self.WKView.configuration.allowsInlineMediaPlayback;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //WKWebView上调用 - [WKWebView goBack]，回退到上一个页面后不会触发window.onload()函数，不会执行JS。
    //WKWebView需要通过scrollView delegate调整滚动速率
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"contentSize"]){
        self.WKView.frame = CGRectMake(0, 55, [UIScreen mainScreen].bounds.size.width,self.WKView.scrollView.contentSize.height);
    }
}

#pragma mark - WKWebView NavigationDelegate
//WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"是否允许这个导航");
    
    if ([navigationAction.request.URL.scheme caseInsensitiveCompare:@"jsToOc"] == NSOrderedSame) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
//! WKWebView在每次加载请求完成后会调用此方法
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError * _Nullable error) {
        self.title = title;
    }];
    //适配暗黑模式
    NSString *backgroundColor = @"";
    NSString *labelColor = @"";
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            backgroundColor = @"\"#001A1A\"";
            labelColor = @"'#FF0000'";
        }else{
            backgroundColor = @"\"#FFFFFF\"";
            labelColor = @"'#666666'";
        }
    } else {
        self.WKView.hidden = NO;
        return;
    }
    //写入JS代码
    [self.WKView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor=%@",backgroundColor] completionHandler:nil];
    [self.WKView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@",labelColor] completionHandler:nil];
    //设置字体
    NSString *fontFamilyStr = @"document.getElementsByTagName('body')[0].style.fontFamily='Arial';";
    [self.WKView evaluateJavaScript:fontFamilyStr completionHandler:nil];
    //设置颜色
    [self.WKView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9098b8'" completionHandler:nil];
    //修改字体大小
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"completionHandler:nil];
    [self.WKView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.fontSize='14px';"completionHandler:nil];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.WKView.hidden = NO;
//    });
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"输出的信息%@",message);
    return completionHandler();

}
//! confirm(message)
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
   
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//直接获取cookie，prompt方法会直接被oc的WKUIDelegate代理中的runJavaScriptTextInputPanelWithPrompt代理方法所捕获到
//js调用oc prompt(prompt, defaultText)
#pragma mark - WKUIDelegate delegate method
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if ([prompt isEqualToString: @"getCookie"]) {
            completionHandler(@"eba7392f-f754-4a56-9c22-aedf3ffb79d8");
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = defaultText;
        }];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(alertController.textFields[0].text);
        }];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    Decides whether to allow or cancel a navigation after its response is known.
    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"跳转到其他的服务器");
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页开始接收网页内容");
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#pragma mark - WKScriptMessageHandler

//! WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name caseInsensitiveCompare:@"jsInvokeOCMethod"] == NSOrderedSame) {
        NSLog(@"消息内容: %@", message.body);
        NSLog(@"方法名: %@", message.name);
        [self.WKView evaluateJavaScript: @"response2JS('Hello return')"
                       completionHandler:^(id response, NSError * error) {
            NSLog(@"response: %@, \nerror: %@", response, error);
        }];
    }
    if ([@"printLog" isEqualToString:message.name]) {
        [self printLog:@"jjj"];
    }
}
- (void)printLog:(NSString *)hhh {
    NSLog(@"response:重新实现js方法");
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
