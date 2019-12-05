//
//  BluetoothInfo.m
//  BlueDemo
//
//  Created by Trista on 16/2/16.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import "BLEDeviceInfo.h"

@implementation BLEDeviceInfo

/**
 *  取得设备名称
 *
 *  @return
 */
- (NSString *)getDeviceName{
    
    //这里还可以获取设备的一个广播名称 NSString *CBName=[advertisementData valueForKeyPath:CBAdvertisementDataLocalNameKey]; 这两个名称一般是不一样的
    if (self.advertisementData&&[self.advertisementData.allKeys containsObject:CBAdvertisementDataLocalNameKey]) {
        
        NSString *cbName=[self.advertisementData valueForKeyPath:CBAdvertisementDataLocalNameKey];
        
        if (cbName&&[cbName length]>0) {
            return cbName;
        }
    }
    
    return self.peripheral.name;
}

@end
