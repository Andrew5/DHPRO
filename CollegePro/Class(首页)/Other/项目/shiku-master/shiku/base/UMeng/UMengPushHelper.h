#import <Foundation/Foundation.h>


@interface UMengPushHelper : NSObject
+ (instancetype)shared;

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
- (void)run:(NSDictionary *)launchOptions;

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
- (void)receive:(NSDictionary *)userInfo;

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
- (void)register:(NSData *)deviceToken;
@end