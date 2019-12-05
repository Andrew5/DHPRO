//
//  AppDelegate.h
//  shiku
//
//  Created by txj on 15/3/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <XZFramework/TabBarController.h>
#import <XZFramework/TabBarItem.h>
//#import "WeiboSDK.h"
#import "WXApi.h"
#import "ZWIntroductionViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
    UILabel *lbCartBadge;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TabBarController* viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) id<WXApiDelegate> delegate_wx;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

