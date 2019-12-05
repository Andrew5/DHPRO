//
//  BluetoothClientManager.h
//  BlueDemo
//
//  Created by Trista on 16/2/16.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDeviceInfo.h"
#import "BLEConnector.h"
#import "BLEConfigDefine.h"


@interface BLECentralManager : NSObject

/**
 *  蓝牙当前状态
 */
@property (nonatomic,readonly) BLEState state;

/**
 *  中心对象
 */
@property (nonatomic,readonly) CBCentralManager *clientmanager;



+ (BLECentralManager *)shareInstance;

/**
 *  获取第一个连接对象
 *
 *  @return
 */
- (BLEConnector *)getFirstConnector;


#pragma mark block

/**
 *  设置蓝牙状态回调
 *
 *  @param aCompletionBlock 蓝牙状态回调block
 */
- (void)setStateChangedBlock:(BLECentralStateChangedBlock)aStateChangedBlock;

/**
 *  设置扫描到蓝牙设备回调
 *
 *  @param aScanBlock 扫描到蓝牙设备回调
 */
- (void)setDeviceScanBlock:(BLECentralDeviceScanBlock)aScanBlock;

/**
 *  设置扫描到多个蓝牙设备回调
 *
 *  @param aDeviceScanCompletedBlock 扫描到多个蓝牙设备回调
 */
- (void)setDeviceScanCompletionBlock:(BLECentralDeviceScanCompletedBlock)aDeviceScanCompletedBlock;

/**
 *  设置蓝牙连接成功
 *
 *  @param aConnectedCompletedBlock 蓝牙连接成功回调
 */
- (void)setConnectedCompletionBlock:(BLECentralConnectSuccessBlock)aConnectedCompletedBlock;

/**
 *  设置蓝牙连接失败
 *
 *  @param aConnectedCompletedBlock 蓝牙连接失败回调
 */
- (void)setConnectFailedBlock:(BLECentralConnectFailedBlock)aFailedBlock;

/**
 *  设置蓝牙断开连接回调
 *
 *  @param aDisconnectBlock 蓝牙断开连接回调
 */
- (void)setDisConnectBlock:(BLECentralDisconnectBlock)aDisconnectBlock;



#pragma mark -扫描

/**
 *  开始扫描
 */
-(void)startScan;

/**
 *  停止扫描
 */
-(void)stopScan;

#pragma mark -连接与取消

/**
 *  连接
 */
-(void)beginConnectWithPeripheral:(CBPeripheral *)peripheral;

/**
 *  取消连接
 */
-(void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral;

/**
 *  取消所有连接
 */
- (void)cancelAllConnect;

@end
