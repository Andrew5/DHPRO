//
//  DeveLoperViewController.h
//  BLEAPP
//
//  Created by Rillakkuma on 16/6/16.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DHBle.h"
#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"
#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
@interface DeveLoperViewController : UIViewController<DHBleDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLock;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) DHBle *sensor;
@property (nonatomic, assign, readwrite) UInt32 deviceId;
@property (nonatomic, assign, readwrite) UInt32 devicePassword;
@property (strong, nonatomic) NSMutableArray *rssi_container;
@end
