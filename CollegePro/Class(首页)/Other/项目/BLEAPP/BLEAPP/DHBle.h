//
//  DHBle.h
//  DHBle
//
//  Created by roryyang on 15/7/6.
//  Copyright (c) 2015年 dh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

/*
 define
 */

#define SERVICE_UUID     0xFEE7
#define CHAR_UUID        0xFEC6

/* API 函数执行结果 */
typedef NS_ENUM(NSInteger, DHBleErrorType) {
    DHBLE_ER_OK = 0,
    DHBLE_ER_NG,
    DHBLE_ER_SENDING, /* 数据正在发送中 */
    DHBLE_ER_NO_CONNECT, /* 设备未连接 */
    DHBLE_ER_DEVICE_ID, /* 设备ID错误 */
};

typedef NS_ENUM(NSInteger, DHBleTxPowerType) {
    TX_POWER_MINUS_23_DBM = 0,
    TX_POWER_MINUS_6_DBM,
    TX_POWER_0_DBM,
    TX_POWER_4_DBM
};

/* 设备结果返回状态 */
typedef NS_ENUM(NSInteger, DHBleResultType) {
    DHBLE_RESULT_OK = 0,
    DHBLE_RESULT_NG,
    DHBLE_RESULT_SYSTEM_ERROR, /* 系统密码错误 */
    DHBLE_RESULT_LOCK_ID_ERROR, /* 锁ID不一致 */
    DHBLE_RESULT_PASSWORD_ERROR, /* 用户密码错误 */
    DHBLE_RESULT_TIMEOUT, /* 超时 */
    DHBLE_RESULT_NO_LOGIN, /* 没有登录 */
    DHBLE_RESULT_KEY_EXIST, /* 钥匙己经存在 */
    DHBLE_RESULT_KEY_FULL, /* 钥匙己满 */
    DHBLE_RESULT_KEY_EMPTY, /* 钥匙为空 */
};

/* 其它钥匙的类型 */
typedef NS_ENUM(NSInteger, DHBleOtherKeyType) {
    DHBLE_KEY_TYPE_CARD = 1, /* 卡片钥匙 */
    DHBLE_KEY_TYPE_PASSWORD, /* 密码钥匙 */
    DHBLE_KEY_TYPE_REMOTE, /* 遥控钥匙 */
};

/* 设备类型 */
typedef NS_ENUM(NSInteger, DHBleDeviceType) {
    TYPE_LOCK_HOME = 0, /*家用门锁*/
    TYPE_LOCK_HOTEL, /*酒店锁*/
    TYPE_LOCK_CARPORT, /*车位锁*/
    TYPe_LOCK_HANG, /*挂锁*/
    TYPE_LOCK_PASSIVE, /*无源电子锁*/
    TYPE_LOCK_ACCESS, /* 门禁 */
    TYPE_DEVICE_TOUCH_SWITCH = 10, /* 触摸开关 */
	TYPE_DEVICE_TOUCH_ADJUST_SWITCH, /* 触摸调光开关 */
    TYPE_DEVICE_WRGB, /* WRGB调光灯*/
    TYPE_DEVICE_LAB = 0x20, /* 电子标签 */
    TYPE_DEVICE_NULL = 0xff, /* 无效 */
};

/* */
typedef NS_ENUM(NSInteger, DHBleOpenCloseType) {
    TYPE_OPEN_LOCK = 0,
    TYPE_CLOSE_LOCK,
};


/* 家用锁的类型 */
typedef NS_ENUM(NSInteger, DHBleHomeKeyType) {
    TYPE_HOME_KEY_ALL = 0,
    TYPE_HOME_KEY_APP,  /* 手机APP */
    TYPE_HOME_KEY_PASSWORD,  /* 密码 */
    TYPE_HOME_KEY_CARD,  /* 卡片 */
    TYPE_HOME_KEY_FINGER_POINT, /* 指纹 */
};



@protocol DHBleDelegate

@optional
- (void)connectDeviceCallBack:(DHBleResultType)result;
- (void)disconnectDeviceCallBack;
- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level;
- (void)scanDeviceEndCallBack;
- (void)updateBluetoothStateCallBack:(UInt8)state;
- (void)didDiscoverServicesCallBack:(DHBleResultType)result;
- (void)didDiscoverCharacteristicsCallBack:(DHBleResultType)result;
- (void)readVerInfoCallBack:(DHBleResultType)result hwInfo:(UInt8*)pHw swInfo:(UInt8*)pSw code:(UInt8)code configFlag:(UInt8)flag;
- (void)readDeviceInfoCallBack:(DHBleResultType)result device:(UInt32)deviceId configStatus:(Byte)status;
- (void)configDeviceCallBack:(DHBleResultType)result;
- (void)readConfigCallBack:(DHBleResultType)result activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime;
- (void)modifyPasswordCallBack:(DHBleResultType)result;
- (void)modifyNameCallBack:(DHBleResultType)result;
- (void)readInputCallBack:(DHBleResultType)result inputStatus:(Byte)status;
- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery;
- (void)resetDevcieCallBack:(DHBleResultType)result;
- (void)readClockCallBack:(DHBleResultType)result year:(UInt16)year month:(Byte)month day:(Byte)day hour:(Byte)hour minute:(Byte)minute second:(Byte)second;
- (void)setClockCallBack:(DHBleResultType)result;

// for ibeacon start
//- (void)readIbeaconConfigCallBack:(DHBleResultType)result advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor;
//- (void)setIbeaconConfigCallBack:(DHBleResultType)result;
- (void)setIbeaconUUIDCallBack:(DHBleResultType)result;
// for ibeacon end

// for config Wifi start
- (void)configWifiCallBack:(DHBleResultType)result;
- (void)configServerCallBack:(DHBleResultType)result;
// for config Wifi end

// for home lock start
- (void)readPaswdAndCardKeyCallBack:(DHBleResultType)result totalKey:(UInt8)total currentKey:(UInt8)current userId:(UInt32)userId keyStatus:(UInt8)status;
- (void)addPaswdAndCardKeyCallBack:(DHBleResultType)result;
- (void)deletePaswdAndCardKeyCallBack:(DHBleResultType)result;
// for home lock end

// for one key start
- (void)oneKeyOpenUserWithSignCallBack:(DHBleResultType)result;
// for one key end
#if 0
// for ibeacon start
- (void)enterRegionCallBack;
- (void)exitRegionCallBack;
- (void)screenTurnOnCallBack;
// for ibeacon end
#endif
- (void)controlDeskCallBack:(DHBleResultType)result; // for test
@end

@interface DHBle :NSObject<CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate>{
    
}
@property (nonatomic, assign) id <DHBleDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion    *myBeacon;


#pragma mark - Methods for controlling the BLKApp Sensor
-(void)bleInit; //controller setup
-(int)scanDevice:(int)timeout;
-(int)scanDeviceWithUUID:(int)timeout;
-(int)stopScanDevice;
-(void)connectDevice:(CBPeripheral *)peripheral;
-(void)disconnectDevice:(CBPeripheral *)peripheral;
-(DHBleErrorType)readVerInfo:(CBPeripheral *)peripheral;
-(DHBleErrorType)readDeviceInfo:(CBPeripheral *)peripheral devicePassword:(UInt32)password;
-(DHBleErrorType)configDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password activeRSSI:(UInt16)level disConnectTime:(UInt16)disConnectTime txPower:(Byte)power activeTime:(UInt16)actTime;
-(DHBleErrorType)readConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)modifyPassword:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId oldPassword:(UInt32)password newPassword:(UInt32)newPaswd;
-(DHBleErrorType)modifyDeviceName:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password deviceName:(char*)name nameLength:(UInt8)length;
-(DHBleErrorType)readInput:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)openDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)closeDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)openDeviceUserId:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password userId:(UInt32)userId;
-(DHBleErrorType)openDeviceExt:(CBPeripheral *)peripheral userId:(UInt32)userId signature:(UInt8*)pSignature sigLength:(UInt8)length;
-(DHBleErrorType)closeDeviceExt:(CBPeripheral *)peripheral userId:(UInt32)userId signature:(UInt8*)pSignature;
-(DHBleErrorType)openLockWithUserSign:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;
-(DHBleErrorType)resetDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(UInt32)getDeviceId:(CBPeripheral *)peripheral;
-(UInt8)getDeviceType:(CBPeripheral *)peripheral;
-(NSString *)getDeviceName:(CBPeripheral *)peripheral;

-(DHBleErrorType)readClock:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;

-(DHBleErrorType)setClock:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password year:(UInt16)year month:(Byte)month day:(Byte)day hour:(Byte)hour minute:(Byte)minute second:(Byte)second;

-(NSString*)generateVisitePassword:(UInt32)deviceId devicePassword:(UInt32)password activeTime:(UInt16)activeTime;

/* for Test */
-(DHBleErrorType)getSignature:(UInt32)deviceId devicePassword:(UInt32)password signature:(UInt8 *)pBuf;

// for ibeacon start
//-(DHBleErrorType)readIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password;
-(DHBleErrorType)setIbeaconConfig:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password
                          advTime:(int)advInt txPower:(int)power main:(int)major sub:(int)minor;

-(DHBleErrorType)setIbeaconUUID:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password UUID:(UInt8 *)pUUID;
// for ibeacon end

// for config Wifi start
-(DHBleErrorType)configWifiSSID:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password SSID:(UInt8 *)pSSID SSIDLength:(UInt8)length;

-(DHBleErrorType)configWifiPassword:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password password:(UInt8 *)pPassword passwordLength:(UInt8)length;

-(DHBleErrorType)configServer:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password port:(UInt16)port ip1:(UInt8)ip1 ip2:(UInt8)ip2 ip3:(UInt8)ip3 ip4:(UInt8)ip4 domain:(UInt8 *)pDomain domainLength:(UInt8)length;
// for config Wifi End

-(DHBleErrorType)operateLockRemote:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;
-(DHBleErrorType)operateLockLocal:(CBPeripheral *)peripheral signData:(UInt8 *)pSign operateType:(UInt8)type;

// for home lock start
-(DHBleErrorType)readPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password keyIndex:(UInt8)index;
-(DHBleErrorType)addPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId KeyInfo:(UInt32)keyInfo activeYear:(UInt16)year activeMonth:(UInt8)month activeDay:(UInt8)day;
-(DHBleErrorType)deletePaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId;
// for home lock end

// for one key start
-(DHBleErrorType)oneKeyReadVerInfo:(CBPeripheral *)peripheral;

-(DHBleErrorType)oneKeyReadDeviceInfo:(CBPeripheral *)peripheral devicePassword:(UInt32)password;

-(DHBleErrorType)oneKeyOpenDevice:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword :(UInt32)password openType:(DHBleOpenCloseType)type;

-(DHBleErrorType)oneKeyOpenDeviceExt:(CBPeripheral *)peripheral userId:(UInt32)userId signature:(UInt8*)pSignature sigLength:(UInt8)length;

-(DHBleErrorType)oneKeyOpenUserWithSign:(CBPeripheral *)peripheral  signData:(UInt8 *)pSign operateType:(DHBleOpenCloseType)type;

-(DHBleErrorType)oneKeyReadPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password keyIndex:(UInt8)index;

-(DHBleErrorType)oneKeyAddPaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId KeyInfo:(UInt32)keyInfo activeYear:(UInt16)year activeMonth:(UInt8)month activeDay:(UInt8)day;

-(DHBleErrorType)oneKeyDeletePaswdAndCardKey:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password type:(UInt8)passwordCard userId:(UInt32)userId;
// for one key end

-(void)getSignData:(UInt8 *)pSign;
#if 0
// for ibeacon start
-(void)initBeacon;
-(void)startBeacon:(NSString *)UUID;
-(void)stopBeacon;
// for ibeacon end
#endif

-(DHBleErrorType)controlDesk:(CBPeripheral *)peripheral deviceNum:(UInt32)deviceId devicePassword:(UInt32)password command:(UInt8)cmd; // for test
@end
