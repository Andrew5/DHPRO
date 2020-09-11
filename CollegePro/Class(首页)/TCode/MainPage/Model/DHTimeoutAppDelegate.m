//
//  DHTimeoutAppDelegate.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/29.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHTimeoutAppDelegate.h"

@implementation DHTimeoutAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidTimeout:)
                                                 name:@"ActionD" object:nil];
    
    return YES;
}
- (void) applicationDidTimeout:(NSNotification *) notif {
    NSLog(@"接受到推送消息");
}
@end
