//
//  BLEConnector.h
//  BlueDemo
//
//  Created by Trista on 16/2/17.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEConfigDefine.h"
#import "BLEDataPack.h"
/**
 *  表示一个连接对象
 */
@interface BLEConnector : NSObject
/**
 *  连接的外围对象
 */
@property (nonatomic,strong) CBPeripheral *ftPeripheral;
/**
 *  表示是否已连接
 *
 */
- (BOOL)isConnected;

#pragma mark -block
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
#pragma mark -数据发送
/**
 *  发送文本内容
 *
 *  message
 */
- (void)sendMessage:(NSString *)message;
/**
 *  发送数据
 *
 *  sendData 要发送的数据 NSData类型
 */
- (void)sendData:(NSData *)msgData;
@end
