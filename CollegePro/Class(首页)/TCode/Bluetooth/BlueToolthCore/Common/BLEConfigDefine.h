//
//  BLEConfigDefine.h
//  BlueDemo
//
//  Created by Trista on 16/2/17.
//  Copyright © 2016年 Trista. All rights reserved.
//

#ifndef BLEConfigDefine_h
#define BLEConfigDefine_h

@class BLEDeviceInfo;

/*********************************蓝牙中心**************************************/

extern NSString *const  kBLEStateChangedNotification;  //蓝牙状态变更
extern NSString *const  kBLEConnectSetupNotification;  //蓝牙建立连接
extern NSString *const  kBLEConnectFailedNotification; //蓝牙连接失败
extern NSString *const  kBLEConnectCloseNotification;  //蓝牙断开连接
extern NSString *const  kBLEScanCompletedNotification; //蓝牙扫描完成
extern NSString *const  kBLEConnectorWritePartialDataNotification;   //发送蓝牙数据
extern NSString *const  kBLEConnectorReceivePartialDataNotification; //接收蓝牙数据

typedef NS_ENUM(NSInteger,BLEState) {
    BLEStateUnknown=0,   //蓝牙未知状态
    BLEStateOpen,        //蓝牙打开状态
    BLEStateClose        //蓝牙关闭状态
};

//蓝牙状态变更
typedef void (^BLECentralStateChangedBlock) (BLEState bleState);
//扫描到单个设备
typedef void (^BLECentralDeviceScanBlock) (BLEDeviceInfo *device);
//扫描到多个设备
typedef void (^BLECentralDeviceScanCompletedBlock) (NSArray *devices);
//蓝牙连接成功
typedef void (^BLECentralConnectSuccessBlock) (CBPeripheral *peripheral);
//蓝牙连接失败
typedef void (^BLECentralConnectFailedBlock) (CBPeripheral *peripheral,NSError *error);
//蓝牙断开连接
typedef void (^BLECentralDisconnectBlock) (CBPeripheral *peripheral,NSError *error);
//接收数据
typedef void (^BLEConnectorReceivePartialDataBlock)(NSData *receiveData);
//发送数据
typedef void (^BLEConnectorWritePartialDataBlock)(NSData *writeData);


/*********************************蓝牙外围*************************************************/

extern NSString *const  kBLEPeripheralWritePartialDataNotification;//发送蓝牙数据
extern NSString *const  kBLEPeripheralReceivePartialDataNotification;//接收蓝牙数据

//接收数据
typedef void (^BLEPeripheralReceivePartialDataBlock) (NSData *receiveData);
//发送数据
typedef void (^BLEPeripheralWritePartialDataBlock) (NSData *writeData);

//蓝牙外围服务配置
#define kBluetoottServiceUUID                  @"FFF0"   //服务器uuid
#define kBluetoottNotiyCharacteristicUUID      @"FFF1"   //通知uuid
#define kBluetoottReadwriteCharacteristicUUID  @"FFF2"   //写入uuid

#endif /* BluetoothConfigDefine_h */
