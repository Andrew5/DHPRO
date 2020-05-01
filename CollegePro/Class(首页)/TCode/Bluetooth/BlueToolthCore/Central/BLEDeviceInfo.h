//
//  BluetoothInfo.h
//  BlueDemo
//
//  Created by Trista on 16/2/16.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDeviceInfo : NSObject

/**
 *  外围设备
 */
@property (nonatomic,strong) CBPeripheral *peripheral;

/**
 *  广播信息
 */
@property (nonatomic,strong) NSDictionary *advertisementData;

/**
 *  蓝牙信号
 */
@property (nonatomic,strong) NSNumber *rssi;

/**
 * 广播名称
 */
@property (nonatomic,strong) NSString *localName;

/**
 *  取得设备名称
 *
 */
- (NSString *)getDeviceName;

@end


//CBPeripheral *peripheral,NSDictionary *advertisementData,NSNumber *rssi
