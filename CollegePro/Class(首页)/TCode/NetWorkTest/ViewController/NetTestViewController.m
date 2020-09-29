//
//  NetTestViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "NetTestViewController.h"
#import "SFNetWorkManager.h"
#import "LHCacheTool.h"
#import "CommentsModel.h"
#import <objc/message.h>
#import "DHHttpRequestLogin.h"
#import "YTKNetwork.h"
#import "SFNetWorkManager.h"
#import "YTKNetworkConfig.h"
#import "DHHttpRequestUserInfo.h"
#import "DHHttpRequestOrders.h"
#import "DHHttpRequestImageFile.h"
#import "DHHttpRequestImageUp.h"
#import "DHHttpRequestLoginLogin.h"
#import "DHHttpRequestUserInfoUserInfo.h"
#import "DHHttpRequestOrdersOrders.h"
#import "NetworkSpeedViewController.h"

#import "LoTest.h"
#import "LHHttpTool.h"
#import "NetWork.h"
#import "SFHttpSessionReq.h"


#define HEAD @"http://192.168.101.62:8080"
#define url(KEY) [NSString stringWithFormat:@"%@%@",HEAD,KEY]

///对象宏(object-like macro)和函数宏(function-like macro)
#define M_PI        3.14159265358979323846264338327950288
#define SELF(x)      x
#define PLUS(x,y) x + y
//错误
//#define MIN(A,B) A < B ? A : B
//正确
#define MIN(A,B) (A < B ? A : B)
@interface NetTestViewController ()<YTKChainRequestDelegate,YTKRequestDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
	__block NSArray *_dataSource;
	
	int count1,count2,count3,count4,count5,coun6,count7,count8;//为创建Timer计时器
	NSTimer *timer1,*timer2,*timer3,*timer4,*timer5,*timer6,*timer7,*timer8;
	

}
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIImageView *userIcon;


@property (nonatomic,assign)dispatch_queue_t queue ;
@property (nonatomic,  copy)NSString *someString;
@property (nonatomic,  copy)NSString *headImageUrl;
@end

@implementation NetTestViewController
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网络测试";
    // Do any additional setup after loading the view.
//    [self httpRequestImage];
//    [self getNetwork];
    
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
    ///网络请求
//    [self getRequestNetwork];
//    [self getBaseRequestNetwork];
    ///请求组
//    [self httpRequestGroup];
    ///头像请求
//    [self.view addSubview:self.headerView];
//    [self requestNetWorkManager];
    UIButton *pushNillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushNillButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushNillButton setFrame:CGRectMake(10.0 ,80.0 ,120.0 ,20.0)];
    pushNillButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00]; //背景颜
    [pushNillButton setTitle:@"加载" forState:(UIControlStateNormal)];
    [pushNillButton addTarget:self action:@selector(loadAddChildViewController) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pushNillButton];
}
- (void)loadAddChildViewController{
    NetworkSpeedViewController *twoVC = [[NetworkSpeedViewController alloc]init];
    __weak typeof(twoVC)weakTwoVC = twoVC;
    twoVC.view.frame = self.view.frame;
    [twoVC setInstantBlock:^(BOOL upSpeed) {
        [weakTwoVC willMoveToParentViewController:nil];
        [weakTwoVC removeFromParentViewController];
        [weakTwoVC.view removeFromSuperview];
    }];
    [self addChildViewController:twoVC];
    [self.view addSubview:twoVC.view];

}
- (void)getRequestNetwork{
    ///获取个人信息
    [self httpRequestUserInfoUserInfo];
    ///登录接口
    [self httpRequestLoginLogin];
}
- (void)getBaseRequestNetwork{
    ///登录接口
    [self httpRequestLogin];
    ///获取个人信息
    [self httpRequestUserInfo];
    ///获取订单列表
    [self httpRequestOrders];
}
- (void)httpRequestLoginLogin{
    DHHttpRequestLoginLogin *login = [[DHHttpRequestLoginLogin alloc]initWithUsername:@"15209930772" password:@"admin123"];
    login.needToken = NO;
    [login startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"15209930772" forKey:@"USERNAME"];
        [defaults setObject:@"admin123" forKey:@"PASSWORD"];
        [DHTool setToken:request.responseObject];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
}
- (void)httpRequestUserInfoUserInfo{
    DHHttpRequestUserInfoUserInfo *reg = [[DHHttpRequestUserInfoUserInfo alloc] init];
    reg.needToken = YES;
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求失败 %@",request.requestUrl);
    }];
}
- (void)httpRequestOrdersOrders{
    
    DHHttpRequestOrdersOrders *reg = [[DHHttpRequestOrdersOrders alloc] init];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求失败 %@",request.requestUrl);
    }];
}
- (void)httpRequestGroup{
    DHHttpRequestLoginLogin *a = [[DHHttpRequestLoginLogin alloc]initWithUsername:@"15209930772" password:@"admin123"];
    DHHttpRequestUserInfoUserInfo *b = [[DHHttpRequestUserInfoUserInfo alloc] init];
    b.needToken = YES;
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[b, a]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"succeed");
        NSArray *requests = batchRequest.requestArray;
        NSLog(@"succeed%@",requests);
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
    }];
    
}


- (void)httpRequestLogin{
//    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
//    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
//    forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
//    [YTKNetworkConfig sharedConfig].debugLogEnabled = NO;  //开启Debug模式
    ///请求成功
    DHHttpRequestLogin *reg = [[DHHttpRequestLogin alloc] initWithUsername:@"15209930772" password:@"admin123"];
    reg.needToken = YES;
    reg.delegate = self;
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//    [chainReq addRequest:reg callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//
//    }];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"15209930772" forKey:@"USERNAME"];
        [defaults setObject:@"admin123" forKey:@"PASSWORD"];
        [DHTool setToken:request.responseObject];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"请求失败");
    }];
}
- (void)httpRequestUserInfo{
//    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
//    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
//    forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
//    [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    DHHttpRequestUserInfo *reg = [[DHHttpRequestUserInfo alloc] init];
    reg.needToken = YES;
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//    [chainReq addRequest:reg callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
//        NSLog(@"个人信息请求数据缓存:%@",baseRequest);
//    }];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"个人信息请求失败 %@",request.requestUrl);
    }];
}
- (void)httpRequestOrders{
    DHHttpRequestOrders *reg = [[DHHttpRequestOrders alloc] init];
    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"订单请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"订单请求失败 %@-----%@",request.responseString,request.requestUrl);
    }];
}


- (void)requestFinished:(__kindof YTKBaseRequest *)request{
    
}
- (void)requestFailed:(__kindof YTKBaseRequest *)request{
    
}

- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, DH_DeviceWidth, (DH_DeviceHeight - 64) * 63/(667 - 64));
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActions:)];
        
        [_headerView addGestureRecognizer:tap];
        UILabel *label = [UILabel new];
        label.text = @"头像";
        label.textAlignment = NSTextAlignmentLeft;
        self.userIcon = [UIImageView new];
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = (DH_DeviceHeight - 64) * 22.5 / (667 - 64);
        self.userIcon.layer.borderColor = [UIColor redColor].CGColor;
        self.userIcon.layer.borderWidth = 1.0;
        NSString *urlString = [NSString stringWithFormat:@"%@%@?x-oss-process=image/resize,w_200",@"https://fedynamic.lilyclass.com/", self.headImageUrl];
        NSURL *imageUrl = [NSURL URLWithString:urlString];
        //            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
        //            self.userIcon.image = [UIImage imageWithData:data];
        [self.userIcon sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"g"] options:SDWebImageRefreshCached];
        
        UIImageView *right = [UIImageView new];
        right.image = [UIImage imageNamed:@"icon_courseList_right.png"];
        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = UIColorFromRGBA(0xe6e6e6, 1.0);
        
        [_headerView addSubview:label];
        [_headerView addSubview:self.userIcon];
        [_headerView addSubview:right];
        [_headerView addSubview:bottomLine];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.left.equalTo(_headerView.mas_left).offset(15);
        }];
        
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.height.mas_equalTo(_headerView).multipliedBy((float) 12/63);
            make.width.mas_equalTo(right.mas_height).multipliedBy((float) 7/12);
            make.right.equalTo(_headerView.mas_right).offset(-15);
        }];
        
        [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView);
            make.height.mas_equalTo(_headerView).multipliedBy((float)45/63);
            make.width.mas_equalTo(self.userIcon.mas_height);
            make.right.equalTo(right.mas_left).offset(-15);
        }];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_left);
            make.height.mas_equalTo(@(1));
            make.right.equalTo(_headerView.mas_right);
            make.bottom.equalTo(_headerView.mas_bottom);
        }];
    }
    return _headerView;
}
- (void)tapActions:(UITapGestureRecognizer *)tap{
    __weak __typeof (self)weakSelf = self;
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否允许编辑（默认为NO）
    imagePickerController.allowsEditing = YES;
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (@available(iOS 13.0, *)) {
        alert.view.overrideUserInterfaceStyle = YES;
    } else {
        // Fallback on earlier versions
    }
    // 设置警告响应事件
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置照片来源为相机
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置进入相机时使用前置或后置摄像头
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;

        // 展示选取照片控制器
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;

        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 添加警告按钮
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    // 展示警告控制器
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.userIcon.image = image;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
        SEL selectorToCall = @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:);
        // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
        UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
        
    }
    
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"file"] = data;
    parameters[@"image"] = image;

    [self uploadUsericonWithParameters:parameters];

}
- (void)uploadUsericonWithParameters:(NSMutableDictionary *)parameters{
    
//    DHHttpRequestImageFile *reg = [[DHHttpRequestImageFile alloc] initImageWithData:parameters[@"file"] WithImage:parameters[@"image"]];
//    [reg setUploadProgressBlock:^(DHHttpRequestImageFile * _Nonnull currentApi, NSProgress * _Nonnull progress) {
//        NSLog(@"头像请求进度,返回数据:%@--%@",currentApi,progress);
//    }];
//    reg.uploadProgressBlock = ^(DHHttpRequestImageFile * _Nonnull currentApi, NSProgress * _Nonnull progress) {
//        NSLog(@"%@",progress);
//    };
//    [reg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"头像请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);
//
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//           NSLog(@"头像请求失败 %@-----%@",request.responseString,request.requestUrl);
//    }];
    
    __weak __typeof (self)weakSelf = self;
    DHHttpRequestImageUp *regreg = [[DHHttpRequestImageUp alloc] initImageWithData:parameters[@"file"] WithImage:parameters[@"image"] WithBase64:@""];
    [regreg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"头像请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);
        weakSelf.headImageUrl = request.responseObject[@"data"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%ldd",(long)request.error.code);
    }];
}
// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        NSLog(@"Image was saved successfully.");
    } else {
        NSLog(@"An error happened while saving the image.");
    }
}
//保存照片成功后的回调
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo {
    
    if (!error) {
        NSLog(@"保存图片到相册成功");
    }else {
        NSLog(@"保存图片到相册发生错误，错误信息%@",error);
    }
}

- (void)requestNetWorkManager{
//    NSString *URL = @"http://api.aixueshi.top:5000/Api/V2/Teacher/Study/Search/V200828";
//    NSDictionary *dic = @{@"Account": @"15962119320", @"DeviceSystemVersion": @"13.6", @"Logitude": @(0.0), @"Latitude": @(0.0), @"Location": @"", @"Password": @"123456", @"DeviceType": @(1), @"DeviceName": @"iPad Pro (12.9-inch)", @"AppBuild": @"2020.08.23.01", @"DeviceUUID": @"F9CF5E5B-AD12-4256-8F72-AE40FEAA8D9E", @"AppVersion": @"1.2.4"};
    //    NSDictionary *param = NSDictionaryOfVariableBindings(UserId,PassWord);

    NSString *accessToken = @"STsid0000001600309746250iDPQH0oFvbFWmMwwvPcLlWmuKDioVjcF";
    NSString *token = @"8c0ec96db02f4053b1c6d227d380c6f7";
    NSDictionary *param = NSDictionaryOfVariableBindings(accessToken,token);
//    NSString *url = @"http://192.168.101.62:8080/api/account/demo";
    NSString *requestURL = url(@"/api/account/demo");
    [[SFNetWorkManager shareManager] requestWithType:(HttpRequestTypePost) withUrlString:requestURL withParaments:param withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"object %@",object);
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:requestURL]];//得到cookie
//        
//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
//        for (NSHTTPCookie *cookie in cookies) {
//            if ([[cookie name] isEqualToString:@"HFSESSION"]) {
//                
//                NSLog(@"===%@",cookie);
//            }
//        }
        

    } withFailureBlock:^(NSError *error) {
        NSLog(@"error %@",error);
    } progress:^(float progress) {

    }];
    
//    __weak __typeof (self)weakSelf = self;
    LoTest *regreg = [[LoTest alloc] initWithToken:token accessToken:accessToken];
    [regreg startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"头像请求数据,返回数据:%@--%@",request.responseString,request.requestUrl);

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"--%ldd",(long)request.error.code);
    }];
    
    [LHHttpTool post:requestURL params:param success:^(NSDictionary *obj) {
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
    
    [NetWork POSTWithUrl:requestURL parameters:param view:self.view ifMBP:YES success:^(id  _Nonnull responseObject) {
        NSLog(@"");
    } fail:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
    
//    [[SFHttpSessionReq shareInstance]POSTRequestWithUrl:requestURL parameters:param resHander:^(NSDictionary * _Nullable resData) {
//        NSLog(@"");
//    } resError:^(NSString * _Nullable error) {
//        NSLog(@"");
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
