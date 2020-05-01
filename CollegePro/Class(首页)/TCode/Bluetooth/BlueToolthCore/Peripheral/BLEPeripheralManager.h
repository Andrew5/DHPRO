//
//  BluetoothServerManager.h
//  BlueDemo
//
//  Created by Trista on 16/2/16.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEConfigDefine.h"

@interface BLEPeripheralManager : NSObject
/**
 *  外围对象
 */
@property (nonatomic,readonly) CBPeripheralManager *serverManager;

/**
 *  蓝牙当前状态
 */
@property (nonatomic,readonly) BLEState state;

+ (BLEPeripheralManager *)shareInstance;

#pragma mark -block

/**
 *  设置蓝牙状态回调
 *
 *  aStateChangedBlock 蓝牙状态回调block
 */
- (void)setStateChangedBlock:(BLECentralStateChangedBlock)aStateChangedBlock;

/**
 *  设置接收数据回调
 *
 *  aReceivePartialDataBlock
 */
- (void)setReceivePartialDataBlock:(BLEPeripheralReceivePartialDataBlock)aReceivePartialDataBlock;

/**
 *  设置接收数据回调
 *
 *  aWritePartialDataBlock
 */
- (void)setWritePartialDataBlock:(BLEPeripheralWritePartialDataBlock)aWritePartialDataBlock;

#pragma mark -服务

/**
 *  添加服务
 */
- (void)startService;

/**
 *  停止服务
 */
- (void)stopService;

#pragma mark -数据发送

/**
 *  发送数据
 *
 *  msgData 要发送的数据 NSData类型
 */
- (void)sendData:(NSData *)msgData;

@end
