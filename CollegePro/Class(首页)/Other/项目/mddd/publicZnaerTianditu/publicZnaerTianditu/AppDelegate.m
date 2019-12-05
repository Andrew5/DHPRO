//
//  AppDelegate.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/2.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "UserInfoStorage.h"
#import "UserManagerHandler.h"
#import "UserEntity.h"
#import "LocationUtil.h"
//#import "XGPush.h"
//#import "XGSetting.h"
#import "MobClick.h"
#import "UserActionHandler.h"

#define LOCATION_INTERVAL 60 //位置上报频率

#define _IPHONE80_ 80000

typedef enum {
    LOGIN_MORE = 1,//多个设备登陆，下线
    
    
}PushState;//推送消息状态

@interface AppDelegate ()
{

    LocationUtil  *_locationUtil;
    NSTimer       *_uploadLocationTimer;//定时上传位置定时器
    UserActionHandler *_userHandler;
    UserEntity *_user;
}
@end

@implementation AppDelegate


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

//友盟统计配置
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APP_KEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //初始化SVProgressHUD
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    UIFont *svFont = [UIFont boldSystemFontOfSize:16.0f];
    [SVProgressHUD setFont:svFont];
    
 //   [self umengTrack];
 /*
    [XGPush startApp:XG_ACCESS_ID appKey:XG_ACCESS_KEY];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };

    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
  
//    if ([self getRequestToken]) {
        MainTabBarController *mainTabBarController = [[MainTabBarController alloc]init];
        self.window.rootViewController = mainTabBarController;

//    }
//    else{
//        LoginViewController *loginController = [[LoginViewController alloc]init];
//        self.window.rootViewController = loginController;
//    }


    
    
  
    dispatch_queue_t queue = dispatch_queue_create("Location_queue", NULL);
    dispatch_async(queue, ^{
        //异步定位和上传位置
        [self startTimer];
    });
    
    if (_locationUtil == nil)
        _locationUtil = [[LocationUtil alloc]init];
   
    return YES;
}


-(BOOL)getRequestToken{
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *userEntity = [storage getUserInfo];
    if (userEntity == nil) {
        return NO;
    }
    
    return YES;
}

//开始定时
- (void)startTimer{
    
    _uploadLocationTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_INTERVAL target:self selector:@selector(uploadLocation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}


//上传位置
- (void)uploadLocation{
 
    if (self.myLocation == nil)
        return;
    
    if (self.myLocation == nil)
        _userHandler = [[UserActionHandler alloc]init];
    
    if (!_user) {
        UserInfoStorage *userStorage = [UserInfoStorage defaultStorage];
        _user =[userStorage getUserInfo];
        
        if (_user == nil)//用户未登录，不上传位置信息
            return;
        
    }
    
    //经纬度非零才上传
    if (self.myLocation.location.coordinate.longitude > 0 && self.myLocation.location.coordinate.latitude > 0) {
        
        NSString *lonlat = [NSString stringWithFormat:@"%f,%f",self.myLocation.location.coordinate.longitude,self.myLocation.location.coordinate.latitude];
        
        NSDictionary *params = @{@"data":lonlat,@"dataType":@"b",@"equipId":_user.equipID};
        
        [_userHandler shareUserLocation:params];
        
        NSLog(@"---%@---",lonlat);
    }
    
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
//    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
//    
//    //删除推送列表中的这一条
//    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    self.deviceToken = deviceToken;
    
//    [XGPush setAccount:@"znaer"];
//    //如果不需要回调
//    self.deviceTokenStr = [XGPush registerDevice:deviceToken];

    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",self.deviceTokenStr);
    
    
    
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //处理推送信息
    [self handlerXGInfo:userInfo];
    //推送反馈(app运行时)
//    [XGPush handleReceiveNotification:userInfo];
}

- (void)handlerXGInfo:(NSDictionary *)userInfo{
    
    NSInteger code = [[userInfo objectForKey:@"code"]
                      integerValue];
    switch (code) {
        case LOGIN_MORE:{
         //发现账号在其他设备登陆，被迫下线
            UserInfoStorage *storage = [[UserInfoStorage alloc]init];
            [storage delUserInfo];//删除用户信息，使其重新登陆
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_NOTIF object:userInfo];
             break;
        }
            
        default:
            break;
    }
    
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
