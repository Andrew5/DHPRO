//
//  NetTestViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "NetTestViewController.h"
#import "SFNetWorkManager.h"
#import "CommentsModel.h"
#import <objc/message.h>
//#import "DataModel.h"
#import "DHHttpRequest.h"
#import "YTKNetwork.h"
#import "DHRequest.h"
#import "SFNetWorkManager.h"
#import "YTKNetworkConfig.h"
#import "DHHttpRequestUserInfo.h"
#import "DHUserInfoRequest.h"
///对象宏(object-like macro)和函数宏(function-like macro)
#define M_PI        3.14159265358979323846264338327950288
#define SELF(x)      x
#define PLUS(x,y) x + y
//错误
//#define MIN(A,B) A < B ? A : B
//正确
#define MIN(A,B) (A < B ? A : B)
@interface NetTestViewController ()<YTKChainRequestDelegate,YTKRequestDelegate>
{
	__block NSArray *_dataSource;
	
	int count1,count2,count3,count4,count5,coun6,count7,count8;//为创建Timer计时器
	NSTimer *timer1,*timer2,*timer3,*timer4,*timer5,*timer6,*timer7,*timer8;
	

}
@property (nonatomic,assign)dispatch_queue_t queue ;
@property (nonatomic,copy)NSString *someString;
@end

@implementation NetTestViewController
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网络测试";
    // Do any additional setup after loading the view.
//    [self getdata];
    [self getNetwork];
//    [self loginRequest];
    double r = 10.0;
    double circlePerimeter = 2 * M_PI * r;
    // => double circlePerimeter = 2 * 3.14159265358979323846264338327950288 * r;

    printf("Pi is %0.7f",M_PI);
    //Pi is 3.1415927
    
    NSString *name = @"Macro Rookie";
    NSLog(@"Hello %@",SELF(name));
    printf("%d\t",PLUS(3,2));
    int a = MIN(1,2);
    printf("%d",a);
    int b = 2 * MIN(3, 4);
    printf("%d",b);
    // => int a = 2 * 3 < 4 ? 3 : 4;
    // => int a = 6 < 4 ? 3 : 4;
    // => int a = 4;
    //因为小于和比较符号的优先级是较低的，所以乘法先被运算了，修正非常简单嘛，加括号就好了。
    int c = MIN(3, 4 < 5 ? 4 : 5);
    printf("%d",c);
}
- (void)getNetwork{
    ///登录接口
    [self httpRequestLoginData];
    ///获取个人信息
    [self httpRequestUserInfo];
}
- (void)httpRequestLoginData{
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
    forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    [YTKNetworkConfig sharedConfig].debugLogEnabled = NO;  //开启Debug模式
    ///请求成功
    DHHttpRequest *reg = [[DHHttpRequest alloc] initWithUsername:@"15209930772" password:@"admin123"];
    reg.needToken = YES;
    reg.delegate = self;
    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
    [chainReq addRequest:reg callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {

    }];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
}
- (void)httpRequestUserInfo{
//    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
//    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
//    forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    
    DHHttpRequestUserInfo *reg = [[DHHttpRequestUserInfo alloc] init];
    reg.needToken = YES;
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//    [chainReq addRequest:reg callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//
//    }];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
}

- (void)loginRequest{
    DHRequest *loginRequest = [[DHRequest alloc]init];
    [loginRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
    
    DHUserInfoRequest *userInfoRequest = [[DHUserInfoRequest alloc]init];
    [userInfoRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[loginRequest, userInfoRequest]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"succeed");
        NSArray *requests = batchRequest.requestArray;
//        GetImageApi *a = (GetImageApi *)requests[0];
//        GetImageApi *b = (GetImageApi *)requests[1];
//        GetImageApi *c = (GetImageApi *)requests[2];
//        GetUserInfoApi *user = (GetUserInfoApi *)requests[3];
        // deal with requests result ...
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
    }];
}
- (void)requestFinished:(__kindof YTKBaseRequest *)request{
    
}
- (void)requestFailed:(__kindof YTKBaseRequest *)request{
    
}
- (void)requestNetWorkManager{
    NSString *URL = @"http://api.aixueshi.top:5000/Api/V2/Teacher/Study/Search/V200828";
    NSDictionary *dic = @{@"Account": @"15962119320", @"DeviceSystemVersion": @"13.6", @"Logitude": @(0.0), @"Latitude": @(0.0), @"Location": @"", @"Password": @"123456", @"DeviceType": @(1), @"DeviceName": @"iPad Pro (12.9-inch)", @"AppBuild": @"2020.08.23.01", @"DeviceUUID": @"F9CF5E5B-AD12-4256-8F72-AE40FEAA8D9E", @"AppVersion": @"1.2.4"};
    //    NSDictionary *param = NSDictionaryOfVariableBindings(UserId,PassWord);
    [[SFNetWorkManager shareManager] requestWithType:(HttpRequestTypePost) withUrlString:URL withParaments:dic withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"object %@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error %@",error);
    } progress:^(float progress) {
        
    }];
//    [[SFNetWorkManager shareManager] requestWithType:HttpRequestTypePost withUrlString:URL withParaments:dic withSuccessBlock:^(NSDictionary *object) {
//        NSLog(@"object %@",object);
//    } withFailureBlock:^(NSError *error) {
//        NSLog(@"error %@",error);
//    } progress:^(float progress) {
//
//    }];
}
#pragma mark GCD- 依赖
- (void)relyOperation{
//    NSOperation
}


// 核心概念：
// 任务：Block  即将任务保存到一个Block中去。
// 队列： 把任务放到队列里面，队列先进先出的原则，把任务一个个取出（放到对应的线程）执行。
// 串行队列：顺序执行。即一个一个的执行。
// 并行队列：同时执行。同时执行很多个任务。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}




- (void)other{
    NSLog(@"%s",__func__);
}
///获取视频首帧图片
-(UIImage *)getImage:(NSString *)videoURL{

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];

    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    gen.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMakeWithSeconds(0.0, 600);

    NSError *error = nil;

    CMTime actualTime;

    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];

    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];

    CGImageRelease(image);

    return thumb;
}
#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}
////消息动态解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(teset)) {
//        Method method = class_getInstanceMethod(self, @selector(other));
//        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
////      class_addMethod([self class], name, (IMP)dynamicAdditionMethodIMP, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
////消息转发
////第一种1.0
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(teset)) {
//        //返回值为nil,相当于没有实现这个方法
//        return [[DataModel alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
////如果需要传参直接在参数列表后面添加就好了
//void dynamicAdditionMethodIMP(id self, SEL _cmd) {
//    NSLog(@"dynamicAdditionMethodIMP");
//}
////第二种2.0
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//{
//    //返回方法签名
//    return [NSMethodSignature signatureWithObjCTypes:"v16@:"];
//}
////NSInvocation 里面包含了: 方法调用者,方法名,参数
//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    //修改方法调用者
//    anInvocation.target = (id)[[DataModel alloc] init];
//    //调用方法
//    [anInvocation invoke];
//
//}

//- (void)model
//{
//    DataModel *persion = ((DataModel *(*)(id, SEL))(void *)objc_msgSend)((id)((DataModel *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("DataModel"), sel_registerName("alloc")), sel_registerName("init"));
//    //第一个参数是消息接受者(receive)persion, 第二个参数是方法签名sel_registerName("teset")
//    ((void (*)(id, SEL))(void *)objc_msgSend)((id)persion, sel_registerName("teset"));
//    
//    //简化后
//    [persion teset];
//    objc_msgSend(persion, sel_registerName("teset"));
//}
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//        [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPMethod:@"POST"];
//
//
//        // NSString * employeeIdStr = @"050f0146-0481-4ca2-ad10-9b70409d9df4";
//
//        // NSDictionary *json = @{@"EmployeeId": employeeIdStr,@"Key" :@"Signature",@"Value":@"卧室已经改过的的哦"};
//        NSDictionary *json = @{@"EmployeeId": employeeIdStr,@"Key" :self.keyStr,@"Value":self.editTextView.text};
//
//        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
//
//        [request setHTTPBody:data];
//
//
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSLog(@"请求回来的内容-----%@",dict);
//            NSLog(@"==＝%@",[dict objectForKey:@"Message"]);
//            // [MBProgressHUD displayHudError:@"保存成功"];
//
//            NSString * errStr = @"上传中...";
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//            hud.labelText = errStr;
//            hud.labelFont = [UIFont systemFontOfSize:14.0f];
//            hud.removeFromSuperViewOnHide = YES;
//            [hud setMode:MBProgressHUDModeCustomView];
//            [[UIApplication sharedApplication].keyWindow addSubview:hud];
//            [hud show:YES];
//            double fDelay = 4.0f;
//
//            if (errStr.length > 10)
//            {
//                fDelay = 4.0f;
//            }
//            [LoginAndRegister getEmployeeInfoForPC];
//            [hud performSelector:@selector(hide:) withObject:@"1" afterDelay:fDelay];
//
//            [self performSelector:@selector(back) withObject:nil afterDelay:4];
//            // [self.navigationController popViewControllerAnimated:YES];
//
//        }];
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
