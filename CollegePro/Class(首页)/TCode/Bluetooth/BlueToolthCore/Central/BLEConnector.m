//
//  BLEConnector.m
//  BlueDemo
//
//  Created by Trista on 16/2/17.
//  Copyright © 2016年 Trista. All rights reserved.
//

#import "BLEConnector.h"
#import "BLECentralManager.h"

NSString * const kBLEConnectorWritePartialDataNotification    = @"kBLEConnectorWritePartialDataNotification";
NSString * const kBLEConnectorReceivePartialDataNotification  = @"kBLEConnectorReceivePartialDataNotification";

@interface BLEConnector ()<CBPeripheralDelegate>{
    
    CBCharacteristic *_notifiCharacteristic;
    CBCharacteristic *_writeCharacteristic;
    NSMutableArray* dataPackList; //<! 待发送报文列表
    BLEDataPack* sendingDataPack; //<! 当前正在发送报文
}

/**
 *  接收数据block
 */
@property (nonatomic,copy) BLEConnectorReceivePartialDataBlock receiveDataCompletedBlock;

/**
 *  发送数据block
 */
@property (nonatomic,copy) BLEConnectorWritePartialDataBlock writeDataCompletedBlock;

@end

@implementation BLEConnector

- (id)init{
    
    if (self=[super init]){
        dataPackList = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)dealloc{
    dataPackList = nil;
    _notifiCharacteristic=nil;
    _writeCharacteristic=nil;
    
}

- (void)setFtPeripheral:(CBPeripheral *)peripheral{
    
    if (_ftPeripheral!=peripheral) {
        _ftPeripheral=peripheral;
        _ftPeripheral.delegate=self;
        [_ftPeripheral discoverServices:nil];
    }
}

/**
 *  表示是否已连接
 *
 *  @return
 */
- (BOOL)isConnected{
    
    if (self.ftPeripheral&&self.ftPeripheral.state==CBPeripheralStateConnected) {
        return YES;
    }
    return NO;
}

#pragma mark -block

/**
 *  设置接收数据回调
 *
 *  @param aReceivePartialDataBlock
 */
- (void)setReceivePartialDataBlock:(BLEPeripheralReceivePartialDataBlock)aReceivePartialDataBlock{
    self.receiveDataCompletedBlock=aReceivePartialDataBlock;
}

/**
 *  设置接收数据回调
 *
 *  @param aWritePartialDataBlock
 */
- (void)setWritePartialDataBlock:(BLEPeripheralWritePartialDataBlock)aWritePartialDataBlock{
    self.writeDataCompletedBlock=aWritePartialDataBlock;
}



#pragma mark -公有方法

/**
 *  发送文本内容
 *
 *  @param message
 */
- (void)sendMessage:(NSString *)message{
    
    //分段发送
    NSData *sendData=[message dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:sendData];
}

/**
 *  发送数据
 *
 *  @param sendData 要发送的数据 NSData类型
 */
- (void)sendData:(NSData *)msgData{
    
    BLEDataPack *mod=[[BLEDataPack alloc] initWithData:msgData];
    [dataPackList addObject:mod];
    
    //如果当前没有发送数据
    if (!sendingDataPack) {
        [self sendNextDataPack];
    }
}



/**
 * @breif 发送下一个数据
 */
- (void)sendNextDataPack{
    sendingDataPack = nil;
    if ([dataPackList count]>0) {
        sendingDataPack=[dataPackList objectAtIndex:0];
        [dataPackList removeObjectAtIndex:0];
        //发送数据
        [self writeData:[sendingDataPack beginSendData]];
    }
}

- (void)writeData:(NSData *)subData{
    if (subData&&self.ftPeripheral&&_writeCharacteristic) {
        [self.ftPeripheral writeValue:subData forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


#pragma mark -CBPeripheralDelegate Methods

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray*)invalidatedServices{
    
}

/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [[BLECentralManager shareInstance] cancelConnectWithPeripheral:peripheral];
        return;
    }
    for (CBService *service in peripheral.services) {
        //查找特征
        [peripheral discoverCharacteristics:nil forService:service];
         
        
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        [[BLECentralManager shareInstance] cancelConnectWithPeripheral:peripheral];
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBluetoottReadwriteCharacteristicUUID]]){
             _writeCharacteristic=characteristic;
        }
        if (characteristic.properties==CBCharacteristicPropertyNotify&&[characteristic.UUID isEqual:[CBUUID UUIDWithString:kBluetoottNotiyCharacteristicUUID]]) {
            _notifiCharacteristic=characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }else{
           
        }
    }
}


/**
 This callback lets us know more data has arrived via notification on the characteristic
 处理蓝牙发过来的数据
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    
    if ([characteristic.value length]==0) {
        return;
    }
    
    NSLog(@"收到蓝牙数据 =%@",characteristic.value);
    
    if (self.receiveDataCompletedBlock) {
        self.receiveDataCompletedBlock(characteristic.value);
    }
    
    //接收数据完成通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectorReceivePartialDataNotification object:characteristic.value];
    
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 中心读取外设实时数据
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying)
    {
        //NSLog(@"Notification began on %@", characteristic);
    }
    else
    { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        //[self.manager cancelPeripheralConnection:self.peripheral];
    }
}

/*
 * 用于检测中心向外设写数据是否成功
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"蓝牙发送数据失败,原因= %@", error.description);
    }else{
        NSLog(@"发送数据成功");
    }
    
    //表示数据全部发送完成
    if (sendingDataPack&&sendingDataPack.isFinished) {
        [self handlerWritePartialData:sendingDataPack.currentData];
        [self sendNextDataPack];
        return;
    }
    
    //发送下一部分数据
    if (sendingDataPack&&!sendingDataPack.isFinished) {
        [self handlerWritePartialData:sendingDataPack.currentData];
        [self writeData:[sendingDataPack beginSendData]];
    }
    
}

#pragma mark -私有方法
- (void)handlerWritePartialData:(NSData *)partialData{
    if (partialData&&[partialData length]>0) {
        //写入通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kBLEConnectorWritePartialDataNotification object:partialData];
        
        if (self.writeDataCompletedBlock) {
            self.writeDataCompletedBlock(partialData);
        }
    }
}

@end
