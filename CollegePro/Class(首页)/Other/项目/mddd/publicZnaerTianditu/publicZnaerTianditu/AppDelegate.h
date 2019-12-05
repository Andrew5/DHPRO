//
//  AppDelegate.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/2.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMapView.h"

#define LOGOUT_NOTIF @"logout"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) NSString *deviceTokenStr;
@property (nonatomic, strong) TUserLocation *myLocation;//手机位置


@end

