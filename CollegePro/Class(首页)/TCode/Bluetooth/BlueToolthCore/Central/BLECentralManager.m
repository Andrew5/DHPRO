//
//  BluetoothClientManager.m
//  BlueDemo
//
//  Created by Trista on 16/2/16.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import "BLECentralManager.h"

NSString * const kBLEStateChangedNotification  = @"kBLEStateChangedNotification";
NSString * const kBLEConnectSetupNotification  = @"kBLEConnectSetupNotification";
NSString * const kBLEConnectFailedNotification = @"kBLEConnectFailedNotification";
NSString * const kBLEConnectCloseNotification  = @"kBLEConnectCloseNotification";
NSString * const kBLEScanCompletedNotification = @"kBLEScanCompletedNotification";


@interface BLECentralManager ()<CBCentralManagerDelegate>{
    
    CBCentralManager *_clientCM;
    BLEState _bleState; //蓝牙状态
}
/**
 *  多个连接对象
 */
@property (nonatomic,strong) NSMutableArray *connetorList;

/**
 *  扫描多个对象
 */
@property (nonatomic,strong) NSMutableArray *scanBlueList;

/**
 *  蓝牙是否初始化完成(初始化完成可扫描)
 */
@property (nonatomic,copy) BLECentralStateChangedBlock bleStateChangedBlock;

/**
 *  扫描到单个设备回调
 */
@property (nonatomic,copy) BLECentralDeviceScanBlock bleDeviceScanBlock;

/**
 *  扫描到多个连接设备 (devices是BluetoothInfo对象集合)
 */
@property (nonatomic,copy) BLECentralDeviceScanCompletedBlock bleDeviceScanCompletedBlock;

/**
 *  连接成功
 */
@property (nonatomic,copy) BLECentralConnectSuccessBlock bleConnectedCompletedBlock;

/**
 *  连接失败
 */
@property (nonatomic,copy) BLECentralConnectFailedBlock bleConnectFailedBlock;

/**
 *  断开连接回调
 */
@property (nonatomic,copy) BLECentralDisconnectBlock disBLEConnectBlock;
@end

@implementation BLECentralManager

@synthesize clientmanager=_clientCM;
@synthesize state=_bleState;

+ (BLECentralManager *)shareInstance
{
    static dispatch_once_t pred = 0;
    __strong static BLECentralManager *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init{
    
    if (self=[super init]) {
        
        
        _bleState=BLEStateUnknown;
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey, nil];
        _clientCM = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
        self.connetorList=[[NSMutableArray alloc] init];
        self.scanBlueList=[[NSMutableArray alloc] init];
    }
    return self;
}

/**
 *  获取第一个连接对象
 *
 *  @return
 */
- (BLEConnector *)getFirstConnector{
    if (self.connetorList.count >0) {
        return [self.connetorList objectAtIndex:0];
    }
    return nil;
}


#pragma mark block

/**
 *  设置蓝牙状态回调
 *
 *  @param aCompletionBlock 蓝牙状态回调block
 */
- (void)setStateChangedBlock:(BLECentralStateChangedBlock)aStateChangedBlock{
    self.bleStateChangedBlock=aStateChangedBlock;
}

/**
 *  设置扫描到蓝牙设备回调
 *
 *  @param aScanBlock 扫描到蓝牙设备回调
 */
- (void)setDeviceScanBlock:(BLECentralDeviceScanBlock)aScanBlock{
    self.bleDeviceScanBlock=aScanBlock;
}

/**
 *  设置扫描到多个蓝牙设备回调
 *
 *  @param aDeviceScanCompletedBlock 扫描到多个蓝牙设备回调
 */
- (void)setDeviceScanCompletionBlock:(BLECentralDeviceScanCompletedBlock)aDeviceScanCompletedBlock{
    self.bleDeviceScanCompletedBlock=aDeviceScanCompletedBlock;
}

/**
 *  设置蓝牙连接成功或失败回调
 *
 *  @param aConnectedCompletedBlock 蓝牙连接成功或失败回调
 */
- (void)setConnectedCompletionBlock:(BLECentralConnectSuccessBlock)aConnectedCompletedBlock{
    self.bleConnectedCompletedBlock=aConnectedCompletedBlock;
}

/**
 *  设置蓝牙连接失败
 *
 *  @param aConnectedCompletedBlock 蓝牙连接失败回调
 */
- (void)setConnectFailedBlock:(BLECentralConnectFailedBlock)aFailedBlock{
    self.bleConnectFailedBlock=aFailedBlock;
}

/**
 *  设置蓝牙断开连接回调
 *
 *  @param aDisconnectBlock 蓝牙断开连接回调
 */
- (void)setDisConnectBlock:(BLECentralDisconnectBlock)aDisconnectBlock{
    self.disBLEConnectBlock=aDisconnectBlock;
}
#pragma mark -扫描
/**
 *  开始扫描
 */
-(void)startScan{
    [self.scanBlueList removeAllObjects];
    if(_bleState==BLEStateOpen)
    {
        [self updateLog:@"开始扫描"];
        [_clientCM scanForPeripheralsWithServices:nil options:nil];
    }
    else
    {
        //弹框提示，请去系统中打开蓝牙
        //[[TKAlertCenter defaultCenter]postAlertWithMessage:NSLocalizedString(@"Please open the Bluetooth on system settings", @"请到系统设置中打开蓝牙")];
    }
}
/**
 *  停止扫描
 */
-(void)stopScan{
    [self.scanBlueList removeAllObjects];
    
    [self updateLog:@"停止扫描"];
    [_clientCM stopScan];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startScan) object:nil];
}
#pragma mark -连接与取消
/**
 *  连接
 */
-(void)beginConnectWithPeripheral:(CBPeripheral *)peripheral
{
    
    //[_clientCM connectPeripheral:peripheral options:nil];
    [_clientCM connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

/**
 *  取消连接
 */
-(void)cancelConnectWithPeripheral:(CBPeripheral *)peripheral
{
    [self removeConnectWithPeripheral:peripheral];
    
}

- (void)cancelAllConnect{
    
    for (BLEConnector *item in self.connetorList) {
        [_clientCM cancelPeripheralConnection:item.ftPeripheral];
    }
    [self.connetorList removeAllObjects];
}

- (void)removeConnectWithPeripheral:(CBPeripheral *)peripheral{
    BOOL isRemove=NO;
    if ([self.connetorList count]>0) {
        for (BLEConnector *item in self.connetorList) {
            if (item.ftPeripheral==peripheral) {
                NSLog(@"取消连接1");
                [self.connetorList removeObject:item];
                isRemove=YES;
                break;
            }
        }
    }
    //未找到删除的元素
    if (!isRemove) {
        [self.connetorList removeAllObjects];
    }
    NSLog(@"取消连接2");
    [_clientCM cancelPeripheralConnection:peripheral];
}

#pragma mark -CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{

    //蓝牙状态
    _bleState=central.state==CBCentralManagerStatePoweredOn?BLEStateOpen:BLEStateClose;
    
    if (self.bleStateChangedBlock) {
        self.bleStateChangedBlock(_bleState);
    }

    
    //如果蓝牙打开则进行扫描
    if (_bleState==BLEStateOpen) {
        [self startScan]; //开始扫描
    }
    
    //蓝牙状态变更通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEStateChangedNotification object:[NSNumber numberWithInteger:_bleState]];
}

/*
 当扫描时会执行这里
 */
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
        //NSLog(@"当扫描到设备:%@",aPeripheral.name);
    
        BLEDeviceInfo *mod=[[BLEDeviceInfo alloc] init];
        mod.peripheral=aPeripheral;
        mod.advertisementData=advertisementData;
        mod.rssi=RSSI;
    
    
        if (self.bleDeviceScanBlock) {
           self.bleDeviceScanBlock(mod);
        }
    
        //添加扫描
        [self addBluetoothWithModel:mod];
        
        
}

/*
 * 已连接到外围设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    //停止扫描
    [self stopScan];
    
    //连接成功处理
    [self addPeripheral:peripheral];
    
    if (self.bleConnectedCompletedBlock) {
        self.bleConnectedCompletedBlock(peripheral);
    }
    NSLog(@"连接成功");
    //连接成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectSetupNotification object:peripheral userInfo:nil];
}
/*
 * 连接到外围设备失败
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    [self cleanupWithPeripheral:peripheral];
    
    if (self.bleConnectFailedBlock) {
        self.bleConnectFailedBlock(peripheral,error);
    }
    
    //连接失败通知
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:error,@"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectFailedNotification object:peripheral userInfo:dic];
}
/*
 * 已断开从机的连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    //连接断开
    [self cancelConnectWithPeripheral:peripheral];
    
    if (self.disBLEConnectBlock) {
        self.disBLEConnectBlock(peripheral,error);
    }
    
    //断开连接通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectCloseNotification object:peripheral userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error", nil]];
}

#pragma mark -
#pragma mark - retrieveConnected
- (void) centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state
{
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    
    CBPeripheral *peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        [self beginConnectWithPeripheral:peripheral];
    }
}
- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    CBPeripheral *peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        if (peripheral) {
            [self beginConnectWithPeripheral:peripheral];
        }
    }
}
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    CBPeripheral *peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        [self beginConnectWithPeripheral:peripheral];
    }
}

#pragma mark - 私有方法
- (void)addPeripheral:(CBPeripheral *)peripheral{
    NSArray *arr=[self.connetorList valueForKeyPath:@"ftPeripheral"];
    if (arr&&[arr count]>0&&[arr containsObject:peripheral]) {
        return;
    }
    BLEConnector *ft=[[BLEConnector alloc] init];
    ft.ftPeripheral=peripheral;
    [self.connetorList addObject:ft];
}

- (void)cleanupWithPeripheral:(CBPeripheral *)peripheral{
    // See if we are subscribed to a characteristic on the peripheral
    if (peripheral.services != nil) {
        for (CBService *service in peripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.isNotifying) {
                        // It is notifying, so unsubscribe
                        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
                        
                        // And we're done.
                        //return;
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self cancelConnectWithPeripheral:peripheral];
}
/**
 *  添加扫描到的设备
 *
 *  mod
 */
- (void)addBluetoothWithModel:(BLEDeviceInfo *)mod{
    
    NSArray *arr=[self.scanBlueList valueForKeyPath:@"peripheral"];
    
    BOOL isExists=NO;
    if (arr&&[arr count]>0) {
        
        if ([arr containsObject:mod.peripheral]) {
            isExists=YES;
        }
    }
    
    if (!isExists) {
        [self.scanBlueList addObject:mod];
    
        
        if (self.bleDeviceScanCompletedBlock) {
            self.bleDeviceScanCompletedBlock(self.scanBlueList);
        }
        //扫描到多个设备连接通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEScanCompletedNotification object:self.scanBlueList];

    }
    
}
-(void)updateLog:(NSString *)s
{
    //用回NSLog，
    //NSLog(@"%@",s );
}

@end
