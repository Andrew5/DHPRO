//
//  AppDelegate.m
//  CollegePro
//
//  Created by jabraknight on 2019/4/30.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "AppDelegate+DHCategory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DHGuidepageViewController.h"
#import "ScreenBlurry.h"
#import "TMotionViewController.h"//碰撞
#import "AvoidCrash.h"
//极光推送
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
//#endif
//
#import <MediaPlayer/MediaPlayerDefines.h>
#import <MediaPlayer/MPRemoteCommandCenter.h>
#import <MediaPlayer/MPRemoteCommand.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPContentItem.h>
#import <MediaPlayer/MPMediaItem.h>
#import <StoreKit/StoreKit.h>//内购
//
#import "showView.h"
#import "DHGuidePageHUD.h"
#import "TRViewController.h"
#import "ViewController.h"
#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"

#import "QDExceptionHandler.h"

#define kUseScreenShotGesture 1
extern CFAbsoluteTime StartTime;
@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>
{
    BMKMapManager* _mapManager;//实例变量
   __block int num;//成员变量
    
}
//@property(nonatomic,strong) UIMutableUserNotificationCategory* categorys;
@property (strong, nonatomic)UIVisualEffectView *visualEffectView;

@end

@implementation AppDelegate

+(void)playSound:(int)soundID{
    SystemSoundID id = soundID;
    AudioServicesPlaySystemSound(id);
    AudioServicesPlaySystemSound(soundID);
    
    //    CFRunLoopRun();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"App启动时间--%f",(CFAbsoluteTimeGetCurrent()-StartTime));
    });
#if DEBUG && SHOW_STATISTICS_DEBUG
    [[HAMLogOutputWindow sharedInstance] setHidden:NO];
#endif
    
#if DEBUG
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    
#endif
    //测试
//    [self remoteControlEventHandler];
//    [self updatelockScreenInfo];
    //获取异常
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    InstallSignalHandler();//信号量截断
    InstallUncaughtExceptionHandler();
    [AvoidCrash becomeEffective];
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:@"AvoidCrashNotification" object:nil];
    // 在App启动后开启远程控制事件, 接收来自锁屏界面和上拉菜单的控制
    [application beginReceivingRemoteControlEvents];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;//控制整个功能是否启用。
    manager.shouldResignOnTouchOutside = YES;//控制点击背景是否收起键盘。
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义。
    manager.enableAutoToolbar = NO;//控制是否显示键盘上的工具条。
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /*分类实现*/
    /*! 版本更新  */
    //    [self VersonUpdate];
    /*! 保存当前时间  */
    [self saveCurrentTime];
    //截屏
    [self screenshot];
    //3DTouch
    [self touch3D];
    /*! 写入数据  */
    [self writeFile];
    self.name = @"kaishi";
    NSLog(@"self.name %@",self.name);
    ///MARK: -极光推送⬇️
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    /**
     appKey
     选择 Web Portal 上 的应用 ，点击“设置”获取其 appkey 值。请确保应用内配置的 appkey 与 Portal 上创建应用后生成的 appkey 一致。
     channel
     指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
     apsForProduction
     1.3.1 版本新增，用于标识当前应用所使用的 APNs 证书环境。
     0（默认值）表示采用的是开发证书，1 表示采用生产证书发布应用。
     注：此字段的值要与 Build Settings的Code Signing 配置的证书环境一致。
     */
    [JPUSHService setupWithOption:launchOptions appKey:@""
                              channel:@"App Store"
                     apsForProduction:YES
                advertisingIdentifier:nil];
///MARK: -极光推送⬆️
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"GqPBelcjdgnnusGN3QjEQ45vjE7YkyE1"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //    float sysVersion=[[UIDevice currentDevice]systemVersion].floatValue;
    //    if (sysVersion>=8.0) {
    //        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    //            UIUserNotificationSettings* newSetting= [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObjects:self.categorys, nil]];
    //        }
    //    }

    //如果已经获得发送通知哦的授权则创建本地通知，否则请求授权（注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置）
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      
                                  }];
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
            }];
            //  > 通知内容
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            // > 通知的title
            content.title = [NSString localizedUserNotificationStringForKey:@"推送的标题" arguments:nil];
            // > 通知的要通知内容
            content.body = [NSString localizedUserNotificationStringForKey:@"======推送的消息体======"
                                                                 arguments:nil];
            // > 通知的提示声音
            content.sound = [UNNotificationSound soundNamed:@"oppo.mp3"];//[UNNotificationSound defaultSound];
            //  > 通知的延时执行
            UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                          triggerWithTimeInterval:5 repeats:NO];
            UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                                  content:content trigger:trigger];
            //添加推送通知，等待通知即可！
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                // > 可在此设置添加后的一些设置
                // > 例如alertVC。。
            }];
        } else {
            // Fallback on earlier versions
        }
    }
/*

    //    接收通知参数
    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo= notification.userInfo;
    if(userInfo)
        //        NSLog(@"appdelegate收到userInfo:%@",userInfo);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            //            while (YES) {
            //                [NSThread sleepForTimeInterval:8];
            //            }
            //        //通知主线程刷新
            //        dispatch_async(dispatch_get_main_queue(), ^{
            //            //回调或者说是通知主线程刷新，
            //        });
        });
    
    
    
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        //        [self addLocationForAlert];
    }else{
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound   categories:nil]];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Alarm:) name:@"Alarm" object:nil];
    //关闭程序后再通过点击通知打开应用获取userInfo
    //接收通知参数
    UILocalNotification *notification=[launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *userInfo= notification.userInfo;

    NSLog(@"didFinishLaunchingWithOptions:The userInfo is %@.",userInfo);
*/
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[DHGuidepageViewController alloc] init]];
    [self.window makeKeyWindow];
    // Override point for customization after application launch.
    return YES;
}

///MARK: -激活状态
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //去除模糊效果
    [ScreenBlurry removeBlurryScreenImage];
    //    if (self.visualEffectView) {
    //
    //        [self.visualEffectView removeFromSuperview];
    //
    //    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
///MARK: -取消激活状态
- (void)applicationWillResignActive:(UIApplication *)application {
    //添加模糊效果
    //     [[UIApplication sharedApplication].keyWindow addSubview:self.visualEffectView];
    
    [ScreenBlurry addBlurryScreenImage];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
///MARK: -进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    //方法一
    //    [self startcount];
    //方法二
    //    [self keepRunning];
    //方法三
    //    UIApplication*   app = [UIApplication sharedApplication];
    //    __block    UIBackgroundTaskIdentifier bgTask;
    //    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
    //        dispatch_async(dispatch_get_main_queue(), ^{            if (bgTask != UIBackgroundTaskInvalid)
    //        {
    //            bgTask = UIBackgroundTaskInvalid;
    //        }
    //        });
    //    }];
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{            if (bgTask != UIBackgroundTaskInvalid)
    //        {
    //            bgTask = UIBackgroundTaskInvalid;
    //        }
    //        });
    //    });
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //方法四
    [self newMethod];
}
///MARK: -程序从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {

    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //进入前台
    //    [self startEnterForground];
    //方法四
    if (_count >= 5*60) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil userInfo:@{@"dict" : [NSNumber numberWithInteger:_count]}];
        _count = 0;
    }
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil userInfo:@{@"dict" : [NSNumber numberWithInteger:num]}];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
///MARK: -程序没有被杀死（处于前台或后台），点击通知后会调用此程序
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"noti:%@",notification);
    // 图标上的数字设置为0
    NSLog(@"noti: %@",notification.userInfo);
    //    application.applicationIconBadgeNumber = 0;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedStringFromTable(@"twenty-EIGHT", @"Localizable", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusicNotification" object:nil];
    if (notification) {
        //        NSDictionary *userInfo =  notification.userInfo;
        //        NSString *obj = [userInfo objectForKey:@"user"];
        //        NSLog(@"在后台时，接收本地通知时触发:%@",obj);
    }
}
///MARK: -远程通知(个推)注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {    // Required
    //    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
///MARK: -Required - 极光推送注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}
/** 统计APNs通知(个推)的点击数 */
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
///MARK: -收到消息调用此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
///MARK: -极光推送
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
///MARK: -极光推送
    [JPUSHService handleRemoteNotification:userInfo];
}
///MARK: -iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
}
///MARK: 调用过用户注册通知方法之后执行（也就是调用完registerUserNotificationSettings:方法之后执行）
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"调用过用户注册通知方法之后执行");
    
}
///MARK: -程序即将退出 App完全退出
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
}
///MARK:  -iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //    NSString *payloadMsg = [response.notification.request.content.userInfo objectForKey:@"payload"];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveNotificationResponse" object:nil userInfo:@{@"dict" : payloadMsg}];
}
///MARK: -远程通知注册失败委托
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}
///MARK: -3DTouch 接收点击事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler API_AVAILABLE(ios(9.0)){
    NSLog(@"shortcutItem %@",shortcutItem.type);
    BaseTabBarViewController *tab = (BaseTabBarViewController *)self.window.rootViewController;
    

    if ([shortcutItem.type  isEqualToString:@"Scan"]){
        Class cls = NSClassFromString(@"GKHScanQCodeViewController");
        UIViewController *tempVCTL = [[cls alloc] init];
        UINavigationController *nav = (UINavigationController *)tab.viewControllers[0];
        [nav pushViewController:tempVCTL animated:YES];
    }
    if ([shortcutItem.type  isEqualToString:@"listen"]){
        Class cls = NSClassFromString(@"DropViewController");
        UIViewController *tempVCTL = [[cls alloc] init];
        UINavigationController *nav = (UINavigationController *)tab.viewControllers[0];
        [nav pushViewController:tempVCTL animated:YES];
    }
}
//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
//void (^ _Nonnull __strong)()' vs '
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^ _Nonnull __strong)(void))completionHandler NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED{
    NSLog(@"+++++++++++++++++++++++");
    if ([identifier isEqualToString:KNotificationActionIdentifileStar]) {
        [application cancelAllLocalNotifications];
        
        [_player stop];
        _number_alarm = 5*60;
        [_timer_alarm setFireDate:[NSDate distantPast]];
        
        
        NSLog(@"----------");
    } else if ([identifier isEqualToString:KNotificationActionIdentifileComment]) {
        
        [application cancelAllLocalNotifications];
        
        [_player stop];
        
        NSLog(@"++++++++++");
        
    }
    
    completionHandler();
}
// 宿主应用
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    //  先加载菜单栏
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [BaseTabBarViewController new];
    [delegate.window makeKeyWindow];
    
    // 处理跳转逻辑
    // 可以先回到应用首页，在跳转
    if ([url.absoluteString hasPrefix:@"CollegeProTodayExtensionDemo"]) {
        if ([url.host isEqualToString:@"enterApp"]) {
            //进入APP
        }else if ([url.host hasSuffix:@"message"]) {
            [self jumpSubVCWithNameTitle:@"消息"];
        }else if ([url.host containsString:@"adress"]){
            [self jumpSubVCWithNameTitle:@"地址管理"];
        }
        else if ([url.host containsString:@"work"]){
            [self jumpSubVCWithNameTitle:@"工作"];
        }
        else if ([url.host containsString:@"my"]){
            [self jumpSubVCWithNameTitle:@"我的"];
        }
        else if ([url.host containsString:@"set"]){
            
        }
    }
    
    NSString *urlStr = url.absoluteString;
    NSString *sechemes = url.scheme;
    if ([urlStr containsString:@"articleTitle"] && [urlStr containsString:@"articleUrl"]) {
        NSRange range1 = [urlStr rangeOfString:@"="];
        NSRange range2 = [urlStr rangeOfString:@"&"];
        NSString *articleTitle = [urlStr substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.location - range1.length)];
        
        NSString *stateStr = [urlStr substringFromIndex:range2.location+1];
        NSRange range3 = [stateStr rangeOfString:@"="];
        NSString *articleUrl = [stateStr substringFromIndex:range3.location+1];
        NSLog(@"%@====%@====%@",articleTitle,articleUrl,sechemes);

        //跳转代码就是跳转到你自己设计的控制器，我这里就不写了
    }

    return YES;
}
///MARK:内购支付监听
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
}

-(void)jumpSubVCWithNameTitle:(NSString *)nameTitle{
    if ([nameTitle isEqualToString:@"消息"]) {
        BaseTabBarViewController *tab = (BaseTabBarViewController *)self.window.rootViewController;
        //跳转首页的第二个控制器
        UINavigationController *nav = (UINavigationController *)tab.viewControllers[0];
        TMotionViewController *proCtl = [[TMotionViewController alloc]init];
        [nav pushViewController:proCtl animated:YES];
        
    }
    if ([nameTitle isEqualToString:@"地址管理"]) {
        BaseTabBarViewController *tab = (BaseTabBarViewController *)self.window.rootViewController;
        tab.selectedIndex = 1;
        [self.window.rootViewController.navigationController pushViewController:tab animated:YES];
    }
}
///MARK: -旋转屏幕
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.allowRotate) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}
//当APP由Universal Links进来，在此方法中进行相应的处理
- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSString *host = webpageURL.host;
        if ([host isEqualToString:@""]) {
            //跳转处理
        }else{
            [[UIApplication sharedApplication]openURL:webpageURL];
        }
    }
    return YES;
}
///MARK: -极光推送⬇️
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

///MARK: -极光推送⬆️
///MARK: 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification{

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
//// 在具体的控制器或其它类中捕获处理远程控制事件
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event
//{
//    // 根据事件的子类型(subtype) 来判断具体的事件类型, 并做出处理
//    switch (event.subtype) {
//        case UIEventSubtypeRemoteControlPlay:
//        case UIEventSubtypeRemoteControlPause: {
//            NSLog(@"执行播放或暂停的相关操作 (锁屏界面和上拉快捷功能菜单处的播放按钮)");
//            break;
//        }
//        case UIEventSubtypeRemoteControlPreviousTrack: {
//            NSLog(@"执行上一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的上一曲按钮)");
//            break;
//        }
//        case UIEventSubtypeRemoteControlNextTrack: {
//            NSLog(@"执行下一曲的相关操作 (锁屏界面和上拉快捷功能菜单处的下一曲按钮)");
//            break;
//        }
//        case UIEventSubtypeRemoteControlTogglePlayPause: {
//            NSLog(@"进行播放/暂停的相关操作 (耳机的播放/暂停按钮)");
//            break;
//        }
//        default:
//            break;
//    }
//}
//// 在需要处理远程控制事件的具体控制器或其它类中实现
//- (void)remoteControlEventHandler
//{
//    // 直接使用sharedCommandCenter来获取MPRemoteCommandCenter的shared实例
//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//
//    // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)
//    commandCenter.playCommand.enabled = YES;
//    // 为播放命令添加响应事件, 在点击后触发
//    [commandCenter.playCommand addTarget:self action:@selector(playAction:)];
//
//    // 播放, 暂停, 上下曲的命令默认都是启用状态, 即enabled默认为YES
//    // 为暂停, 上一曲, 下一曲分别添加对应的响应事件
//    [commandCenter.pauseCommand addTarget:self action:@selector(pauseAction:)];
//    [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackAction:)];
//    [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackAction:)];
//
//    // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
//    commandCenter.togglePlayPauseCommand.enabled = YES;
//    // 为耳机的按钮操作添加相关的响应事件
//    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(playOrPauseAction:)];
//
//    // 添加"喜欢"按钮, 需要启用, 并且设置了相关Action后才会生效
//    [MPRemoteCommandCenter sharedCommandCenter].likeCommand.enabled = YES;
//    [[MPRemoteCommandCenter sharedCommandCenter].likeCommand addTarget:self action:@selector(likeItemAction)];
//    [MPRemoteCommandCenter sharedCommandCenter].likeCommand.localizedTitle = @"喜欢";
//
//    // 添加"不喜欢"按钮
//    [MPRemoteCommandCenter sharedCommandCenter].dislikeCommand.enabled = YES;
//    // 自定义该按钮的响应事件, 实现在点击"不喜欢"时去执行上一首的功能
//    [[MPRemoteCommandCenter sharedCommandCenter].dislikeCommand
//     addTarget:self action:@selector(previousCommandAction)];
//    [MPRemoteCommandCenter
//     // 自定义"不喜欢"的标题, 伪装成"上一首"
//     sharedCommandCenter].dislikeCommand.localizedTitle = @"上一首";
//}
//- (void)updatelockScreenInfo
//{
//    // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
//    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
//
//    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
////    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]     initWithImage:[UIImage imageNamed:@"cell.png"]];
//    UIImage *img = [UIImage imageNamed:@"cell.png"];
//    if (@available(iOS 10.0, *)) {
//        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]     initWithBoundsSize:CGSizeMake(100, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
//            return img;
//        }];
//
//
//        // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
//        infoCenter.nowPlayingInfo = @{
//                                      // 歌曲名
//                                      MPMediaItemPropertyTitle : @"过火",
//                                      // 艺术家名
//                                      MPMediaItemPropertyArtist : @"张信哲",
//                                      // 专辑名字
//                                      MPMediaItemPropertyAlbumTitle : @"宽容",
//                                      // 歌曲总时长
//                                      MPMediaItemPropertyPlaybackDuration : @(3.0),
//                                      // 歌曲的当前时间
//                                      MPNowPlayingInfoPropertyElapsedPlaybackTime : @(0.0),
//                                      // 歌曲的插图, 类型是MPMeidaItemArtwork对象
//                                      MPMediaItemPropertyArtwork : artwork,
//
//                                      // 无效的, 歌词的展示是通过图片绘制完成的, 即将歌词绘制到歌曲插图, 通过更新插图来实现歌词的更新的
//                                      // MPMediaItemPropertyLyrics : lyric.content,
//                                      };
//    } else {
//        // Fallback on earlier versions
//    }
//}
- (void)playAction:(id)action{
    NSLog(@"播放");
}
- (void)pauseAction:(id)action{
    NSLog(@"暂停");
}
- (void)nextTrackAction:(id)action{
    NSLog(@"下一曲");
}
- (void)previousTrackAction:(id)action{
    NSLog(@"暂停");
}
- (void)playOrPauseAction:(id)action{
    NSLog(@"耳机的按钮");
}
- (void)likeItemAction{
    NSLog(@"喜欢");
}
- (void)previousCommandAction{
    NSLog(@"不喜欢");
}

///MARK: - 私有方法
///MARK: 添加本地通知
//- (void) addLocalNotification{
//
//    //    NSLog(@"22222");
//    [UIApplication sharedApplication].delegate = self;
//
//    UILocalNotification * notification=[[UILocalNotification alloc] init];
//
//    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
//
//    notification.alertBody=@"闹钟响了。。。。。。";
//
//    notification.repeatInterval=NSCalendarUnitDay;
//
//    notification.applicationIconBadgeNumber=1;
//    notification.hasAction = YES;
//    notification.category = KNotificationCategoryIdentifile;
//
//    notification.userInfo=@{@"name":@"zhangsan"};
//
//
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//
//}


- (void)Alarm:(NSNotification *)noti{
    NSDictionary *dict = noti.object;
    NSLog(@"闹钟-%@",dict[@"Alarm"]) ;
//    [self ViewControllerSendTime:(NSUInteger)dict[@"length"]];
}
- (void)newMethod{
    NSLog(@"### -->backgroundinghandler");
    __weak typeof(self) weakSelf = self;
    UIApplication *app = [UIApplication sharedApplication];
    _backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            if( weakSelf.backgroundTaskIdentifier != UIBackgroundTaskInvalid){
                weakSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            }
        });
        NSLog(@"====任务完成了。。。。。。。。。。。。。。。===>");
        // [app endBackgroundTask:bgTask];
        
    }];
    
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
            weakSelf.count++;
            //            dispatch_async(dispatch_get_main_queue(),^{
            //                [UIApplication sharedApplication].applicationIconBadgeNumber = _count;
            //            });
            if (weakSelf.count >= 5*60) {
                NSLog(@"任务执行完毕，主动调用该方法结束任务");
                break;
                //                [self endBackgroundTask]; // 任务执行完毕，主动调用该方法结束任务
            }
            
            sleep(1);
        }
        
    });
}
///MARK: -后台计时5分钟
- (void)startcount {
    _number = 0;
    
    self.backgroundTaskIdentifier =[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^( void) {
        [self endBackgroundTask];
        
    }];
    
    self.timer =[NSTimer scheduledTimerWithTimeInterval:1.0f
                 
                                                 target:self
                 
                                               selector:@selector(timerMethod:)     userInfo:nil
                 
                                                repeats:YES];
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}
#pragma  启动定时器 检测系统派单

- (void) endBackgroundTask{
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    AppDelegate *weakSelf = self;
    
    dispatch_async(mainQueue, ^(void) {
        
        AppDelegate *strongSelf = weakSelf;
        
        if (strongSelf != nil){
            
            [strongSelf.timer invalidate];// 停止定时器
            
            /*
             每个对 beginBackgroundTaskWithExpirationHandler:方法的调用
             必须要相应的调用 endBackgroundTask:方法。这样，来告诉应用程序你已经执行完成了。
             也就是说,我们向 iOS 要更多时间来完成一个任务,那么我们必须告诉 iOS 你什么时候能完成那个任务。
             也就是要告诉应用程序：“好借好还”。
             标记指定的后台任务完成
             */
            
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            
            // 销毁后台任务标识符
            
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            
        }
        
    });
    
}
- (void) timerMethod:(NSTimer *)paramSender{
//
//    _number  ++;
//
//    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
//
//    if (backgroundTimeRemaining == DBL_MAX){
//        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:_number];
//        if (_number>=5*60){
//            [self addLocationForAlert:_number];
//            [self endBackgroundTask];
//
//        }
//        //        if (_number % 5 == 0) {
//        //            NSLog(@"_numFlag %ld",(long)_number);
//        //            if (_number>=100){[self endBackgroundTask];}
//        //        }
//
//    } else {
//
//        NSLog(@"Background Time Remaining = %.02f Seconds", backgroundTimeRemaining);
//
//    }
//
}
//- (void)startEnterForground{
//    [self.timer invalidate];
//
//    self.timer = nil;
//
//    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
//
//    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
//
//    if (_number==5*60){
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil userInfo:@{@"dict" : [NSNumber numberWithInteger:_number]}];
//    }
//}
//- (void) addLocationForAlert:(NSInteger)num{
//
//    //定义本地通知对象
//    UILocalNotification *notification = [[UILocalNotification alloc]init];
//    //设置调用时间
//    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];//通知触发时间，10s之后
//    notification.repeatInterval = 0; //通知重复次数
//
//    //设置通知属性
//    notification.alertBody = @"后台执行时间已到";//通知主体
//    notification.applicationIconBadgeNumber = num;//应用程序右上角显示的未读消息数
//    notification.alertAction = @"滑动打开";//待机界面的滑动动作提示
//    [notification setAlertTitle:@"xxxxApp名称"];
//    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片，这里使用程序启动图片
//    notification.soundName= UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//    notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
//    //调用通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//
//}

- (void)writeFile{
    ///  路径 如无则自动创建一个
    NSArray *pathArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *strPath=[pathArr lastObject];
    
    NSString *strFinalPath=[NSString stringWithFormat:@"%@/myfile.txt",strPath];
    
    // 写入
    NSString *strData=@"123";
    
    NSData *data=[strData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arrData = [[NSArray alloc]initWithObjects:@"hello",@"asdf", nil];
    //写入数据
    BOOL aResult =[strData writeToFile:strFinalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    BOOL bResult=[data writeToFile:strFinalPath atomically:YES];
    BOOL cResult=[arrData writeToFile:strFinalPath atomically:YES];
    if (aResult) { NSLog(@"strData 文件写入成功"); }
    if (bResult) { NSLog(@"data 文件写入成功"); }
    if (cResult) { NSLog(@"arrData 文件写入成功"); }
}

- (void)keepRunning {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer_alarm = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"后台运行时间 %d",self->num);
            weakSelf.number_alarm++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].applicationIconBadgeNumber = weakSelf.number_alarm;
            });
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)ViewControllerSendTime:(NSInteger)time{
    self.number_alarm = time;
    NSLog(@"后台计时++++%ld",(long)self.number);
    _timer_alarm = nil;
    if (_timer_alarm == nil) {
        //每隔1秒刷新一次页面
        
        _timer_alarm=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [_timer_alarm setFireDate:[NSDate distantPast]];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer_alarm forMode:NSRunLoopCommonModes];
        
        NSLog(@"开始倒计时.....");
        
    }
    else
    {
        [_timer_alarm setFireDate:[NSDate distantPast]];
    }
}
- (void) runAction{
    _number_alarm--;
    if (_number_alarm == 0) {
        //后台播放音频设置
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        //让app支持接受远程控制事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        //提示框弹出的同时，开始响闹钟
        
        NSString * path=[[NSBundle mainBundle]pathForResource:@"HandClap铃声A_铃声之家cnwav.mp3" ofType:nil];
        
        NSURL * url=[NSURL fileURLWithPath:path];
        
        NSError * error;
        
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        
        _player.numberOfLoops=-1;    //无限循环  =0 一遍   =1 两遍    =2 三遍     =负数  单曲循环
        
        _player.volume=2;          //音量
        
        [_player prepareToPlay];    //准备工作
        
        [_timer_alarm setFireDate:[NSDate distantFuture]];
        
        [_player play];
//        [self registerLocalNotification];
    }
}

//- (void)registerLocalNotification
//{
//    NSLog(@"4444");
//
//    UIMutableUserNotificationAction* action1 = [[UIMutableUserNotificationAction alloc] init];
//
//    action1.identifier = KNotificationActionIdentifileStar;
//    action1.authenticationRequired = NO;
//    action1.destructive = NO;
//    action1.activationMode = UIUserNotificationActivationModeBackground;
//    action1.title = @"五分钟后响";
//    UIMutableUserNotificationAction* action2 = [[UIMutableUserNotificationAction alloc] init];
//
//    action2.identifier = KNotificationActionIdentifileComment;
//    action2.title = @"关闭闹钟";
//    action2.authenticationRequired = NO;
//    action2.destructive = NO;
//    action2.activationMode = UIUserNotificationActivationModeBackground;
//
//    self.categorys = [[UIMutableUserNotificationCategory alloc] init];
//    self.categorys.identifier = KNotificationCategoryIdentifile;
//    [self.categorys setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
//    UIUserNotificationSettings* newSetting= [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:self.categorys]];
//
//    [[UIApplication sharedApplication] registerUserNotificationSettings:newSetting];
//
//    if(newSetting.types==UIUserNotificationTypeNone){
//        NSLog(@"aaaaaaaaaaa");
//        UIUserNotificationSettings* newSetting= [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:self.categorys]];
//
//        [[UIApplication sharedApplication] registerUserNotificationSettings:newSetting];
//    }else{
//        NSLog(@"bbbbbbbbbbb");
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        [self addLocalNotification];
//    }
//}





//截取当前视图为图片
- (UIImage *)snapshot:(UIView *)view

{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
    
}
///MARK: ----------- 当前屏幕截屏 -----------
+ (UIImage *)screenShot {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(screenSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        
        if ([window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, window.center.x, window.center.y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context, -[window bounds].size.width * [[window layer] anchorPoint].x, -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
        
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
///MARK: 后台模糊效果
- (UIVisualEffectView *)visualEffectView{
    
    if (!_visualEffectView) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        _visualEffectView.frame = [UIScreen mainScreen].bounds;
        
    }
    
    return _visualEffectView;
    
}
///MARK: 崩溃日志收集
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
    //本地日志打印
    [DHTool writeLocalCacheDataToCachesFolderWithKey:[NSString stringWithFormat:@"A_%@.log",[DHTool getCurrectTimeWithPar:@"yyyy-MM-dd-HH-mm-ss-SSS"]] fileName:@"exception"];

}
@end
