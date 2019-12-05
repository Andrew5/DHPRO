#import "AppDelegate.h"

#import "HomeMapViewController.h"
#import "UserViewController.h"
#import "CategoryViewController.h"
#import "CartViewController.h"
#import "HomeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "sys/utsname.h"
#import "UMengPushHelper.h"
#import "GuideViews.h"
@implementation AppDelegate

//18768473750  123456

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UMengPushHelper shared] run:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = BG_COLOR;
    self.window.autoresizesSubviews = YES;

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBMPAppKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    [ShareSDK registerApp:@"76acdd4dbf70"];//字符串api20为您的ShareSDK的AppKey

    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:kAppKey
                               appSecret:kAppSecret
                             redirectUri:@"http://www.sharesdk.cn"];
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK connectSinaWeiboWithAppKey:kAppKey
//                               appSecret:kAppSecret
//                             redirectUri:@"http://www.sharesdk.cn"
//                             weiboSDKCls:[WeiboSDK class]];

    //    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
    //                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
    //                                redirectUri:@"http://www.sharesdk.cn"
    //                                   wbApiCls:[WeiboApi class]];

    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:kQQAppKey
                           appSecret:kQQAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];

    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:kQQAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];

    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:kWXAppKey
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:kWXAppKey
                           appSecret:kWXAppSecret
                           wechatCls:[WXApi class]];

    TConfig *config = [TConfig shared];
    config.APP_MAIN_COLOR = MAIN_COLOR;
    config.APP_SPLITE_COLOR = BG_COLOR;
    config.backendURL = [NSString stringWithFormat:@"%@",url_share];//@"http://api.shiku.com/buyerApi";
    config.OAuthAccessTokenURL = @"http://api.shiku.com/shiku/buyerApi/user/login";
    App *app = [App shared];

    app.manager = [AFHTTPRequestOperationManager manager];
    app.manager.requestSerializer.HTTPShouldHandleCookies = YES;
    [app.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [[UserBackend shared] restore];
    EmptyViewController *c = [EmptyViewController shared];
    [c bind];

    [self setupViewControllers];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self customizeInterface];
    [self makeGuideView];


    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunchshiku"];
    }
    //显示引导界面
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunchshiku"]) {
        NSArray *coverImageNames = @[ @"guide2.jpg", @"guide3.jpg", @"guide4.jpg", @"guide5.jpg"];

        if ([[self deviceString] isEqualToString:@"4"]) {
            coverImageNames = @[@"guid2_4.jpg", @"guid3_4.jpg", @"guid4_4.jpg", @"guid5_4.jpg"];
        }

        UIButton *enterButton = [UIButton new];
        [enterButton setTitle:@"开始购物" forState:UIControlStateNormal];
        enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
        enterButton.layer.borderWidth = .3;
        enterButton.layer.cornerRadius = 5;
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:coverImageNames button:enterButton];
        [self.window addSubview:self.introductionView.view];
       
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            [weakSelf.introductionView.view removeFromSuperview];
            weakSelf.introductionView = nil;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunchshiku"];

        };
    }
    return YES;
}
- (void)makeGuideView
{
    NSUserDefaults *guide = [NSUserDefaults standardUserDefaults];
    
    BOOL hasGuide = [[guide objectForKey:@"guide"] boolValue];
    
    if (hasGuide) {
        
        return;
    }
    GuideViews *guideView = [[GuideViews alloc]initWithFrame:[UIScreen mainScreen].bounds];
    NSLog(@"%f",guideView.frame.size.height);
    guideView.backgroundColor = [UIColor blackColor];
    [guideView makeGuideViewWithComplete:^{
        [guideView removeFromSuperview];
        [guide setValue:[NSNumber numberWithBool:YES] forKey:@"guide"];
    }];
    [self.window addSubview:guideView];
//    [self.window bringSubviewToFront:guideView];
}

//推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[UMengPushHelper shared] receive:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"----------------------%@",deviceToken);
    [[UMengPushHelper shared] register:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作

}
- (void)applicationDidEnterBackground:(UIApplication *)application{
//后台调用
}
- (NSString *)deviceString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"4";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"]) return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"]) return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


#pragma mark- tabbarcontroller
//我有改过
- (void)setupViewControllers {

    UIViewController *secondViewController = [[UserLikeViewController alloc] init];
    UDNavigationController *secondNavigationController = [[UDNavigationController alloc]
            initWithRootViewController:secondViewController];

    UIViewController *thirdViewController = [[HomeMapViewController alloc] init];
    UDNavigationController *thirdNavigationController = [[UDNavigationController alloc]
            initWithRootViewController:thirdViewController];

    CartViewController *fourthViewController = [[CartViewController alloc] init];
    [fourthViewController setup];
    UDNavigationController *fourthNavigationController = [[UDNavigationController alloc]
            initWithRootViewController:fourthViewController];

    UIViewController *fifthViewController = [[UserViewController alloc] init];
    UDNavigationController *fifthNavigationController = [[UDNavigationController alloc]
            initWithRootViewController:fifthViewController];

    NSArray *titles = @[@"首页", @"购物车", @"喜欢", @"我的"];

    TabBarController *tabBarController = [[TabBarController alloc] init];

    [tabBarController                            setViewControllers:@[ thirdNavigationController,fourthNavigationController, secondNavigationController, fifthNavigationController] withTitles:titles];
    tabBarController.selectedIndex = 0;
    
        lbCartBadge = [UILabel new];
        lbCartBadge.layer.cornerRadius=8;
        lbCartBadge.layer.masksToBounds =YES;
        lbCartBadge.text=[NSString stringWithFormat:@"%d",[[Cart shared] getTotalAmount]];
        [lbCartBadge setNumberOfLines:0];
        lbCartBadge.lineBreakMode = NSLineBreakByWordWrapping;
        lbCartBadge.font=FONT_SMALL;
        lbCartBadge.textAlignment=NSTextAlignmentCenter;
        lbCartBadge.textColor=WHITE_COLOR;
        lbCartBadge.backgroundColor=MAIN_COLOR2;
        lbCartBadge.hidden= YES;
    
        UIView *view = (UIView*)tabBarController.tabBar.subviews[2];
        [view addSubview:lbCartBadge];
        [lbCartBadge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view).offset(-25);
            make.top.equalTo(view).offset(5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    
    self.viewController = tabBarController;

    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(TabBarController *)tabBarController {
    UIImage *unfinishedImage = [UIImage imageNamed:@"selected"];
    UIImage *finishedImage = [UIImage imageNamed:@"normal"];
    
    NSArray *tabBarItemSelectImages = @[@"threeS.png", @"fourS.png", @"twoS.png", @"sixS.png"];
    
    NSArray *tabBarItemImages = @[@"three.png", @"four.png", @"two.png", @"six.png"];

//    NSArray *tabBarItemImages = @[@"one.png", @"two.png", @"three.png", @"four.png", @"six.png"];
    NSInteger index = 0;
    for (TabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                                                [tabBarItemSelectImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                                                  [tabBarItemImages objectAtIndex:index]]];

        NSDictionary *unselectedTitleAttributes;
        NSDictionary *selectedTitleAttributes;

        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            unselectedTitleAttributes = @{
                    NSFontAttributeName : [UIFont systemFontOfSize:12],
                    NSForegroundColorAttributeName : TEXT_COLOR_DARK,
            };
            selectedTitleAttributes = @{
                    NSFontAttributeName : [UIFont systemFontOfSize:12],
                    NSForegroundColorAttributeName : RGBCOLORV(0x7a9c5c),
            };//MAIN_COLOR
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            unselectedTitleAttributes = @{
                                          UITextAttributeFont: [UIFont systemFontOfSize:12],
                                          UITextAttributeTextColor:TEXT_COLOR_DARK,
                                          };
            selectedTitleAttributes = @{
                                        UITextAttributeFont: [UIFont systemFontOfSize:12],
                                        UITextAttributeTextColor:MAIN_COLOR,
                                        };
#endif
        }

        item.selectedTitleAttributes = selectedTitleAttributes;
        item.unselectedTitleAttributes = unselectedTitleAttributes;

        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];

        index++;
    }
}


- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

    NSDictionary *textAttributes = nil;

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes = @{
                NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                NSForegroundColorAttributeName : [UIColor whiteColor],
        };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        //        backgroundImage = [UIImage imageNamed:@"bigShadow"];
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"shiku" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"shiku.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}





//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int) response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse *sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse *) response;
//        NSString *accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken) {
//            self.wbtoken = accessToken;
//        }
//        NSString *userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
//        [alert show];
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int) response.statusCode, [(WBAuthorizeResponse *) response userID], [(WBAuthorizeResponse *) response accessToken], NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//
//        self.wbtoken = [(WBAuthorizeResponse *) response accessToken];
//        self.wbCurrentUserID = [(WBAuthorizeResponse *) response userID];
//        [alert show];
//    }
//    else if ([response isKindOfClass:WBPaymentResponse.class]) {
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int) response.statusCode, [(WBPaymentResponse *) response payStatusCode], [(WBPaymentResponse *) response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *string = [url absoluteString];

    if ([string hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([string hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self.delegate_wx];
    }
    else if ([string hasPrefix:@"ali"]) {

        if ([url.host isEqualToString:@"safepay"]) {

            [[AlipaySDK defaultService] processAuth_V2Result:url
                                             standbyCallback:^(NSDictionary *resultDic) {
                                                 NSLog(@"result = %@", resultDic);
//                                                 NSString *resultStr = resultDic[@"result"];
                                             }];
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSLog(@"result = %@", resultDic);
//                                                          NSString *resultStr = resultDic[@"result"];
                                                      }];

        }
        return YES;

    }
    return YES;
//    return [WeiboSDK handleOpenURL:url delegate:self.delegate_weibo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSString *string = [url absoluteString];

    if ([string hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([string hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
//    return [WeiboSDK handleOpenURL:url delegate:self.delegate_weibo];
}

- (void)sendAuthRequest {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    [WXApi sendReq:req];
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
