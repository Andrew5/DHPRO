//
//  CollegeBlEViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/1/21.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "CollegeBlEViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define MyDeviceName @"AirPods Pro"
static NSString *myCharacteristicUUID = @"E1F9B835-7E47-413D-AF94-C68E574B8F7E";
static NSString *myServicUUID = @"0D0E9CAC-9C77-56A4-32AA-431B7DF85DA1";
@interface CollegeBlEViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
//@property (weak, nonatomic) IBOutlet UITextField *editText;
//@property (weak, nonatomic) IBOutlet UILabel *resultText;
@property (copy, nonatomic) NSString *editText;
@end

@implementation CollegeBlEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = CGRectMake(20, 150, 200, 200);
    //    [redBtn setBounds:CGRectMake(0, 0, 200, 200)];
    redBtn.backgroundColor = [UIColor redColor];
    [redBtn setTitle:@"normal" forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(sendClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:redBtn];
    self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

//检查App的设备BLE是否可用 （ensure that Bluetooth low energy is supported and available to use on the central device）
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state){
        case CBCentralManagerStatePoweredOn:
            //discover what peripheral devices are available for your app to connect to
            //第一个参数为CBUUID的数组，需要搜索特点服务的蓝牙设备，只要每搜索到一个符合条件的蓝牙设备都会调用didDiscoverPeripheral代理方法
            [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
//            [self.centralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"9BD708D7-64C7-4E9F-9DED-F6B6C4551967"]]
//            options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"peripheral.name %@",peripheral.name);
    //找到需要的蓝牙设备，停止搜素，保存数据
    if([peripheral.name isEqualToString:MyDeviceName]){
        _discoveredPeripheral = peripheral;
        [_centralMgr connectPeripheral:peripheral options:nil];
    }
    ///
    if (_discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        _discoveredPeripheral = peripheral;
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralMgr connectPeripheral:peripheral options:nil];
    }
    ///
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    ///
    [self.centralMgr stopScan];
    ///
//    peripheral.delegate = self;
//    [self.discoveredPeripheral discoverServices:@[[CBUUID UUIDWithString:@"9BD708D7-64C7-4E9F-9DED-F6B6C4551967"]]];
    //Before you begin interacting with the peripheral, you should set the peripheral’s delegate to ensure that it receives the appropriate callbacks（设置代理）
    [_discoveredPeripheral setDelegate:self];
    //discover all of the services that a peripheral offers,搜索服务,回调didDiscoverServices
    ///
//    [_discoveredPeripheral discoverServices:nil];
    ///
    ///MAC 地址
    [_discoveredPeripheral discoverServices:@[[CBUUID UUIDWithString:myServicUUID]]];

}

//连接失败，就会得到回调：
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //此时连接发生错误
    NSLog(@"connected periphheral failed");
    ///
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:myCharacteristicUUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
    ///
}


//获取服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    for (CBService *s in peripheral.services){
        NSLog(@"Service found with UUID : %@", s.UUID);
        //Discovering all of the characteristics of a service,回调didDiscoverCharacteristicsForService
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:myCharacteristicUUID]] forService:s];
        ///
//        [s.peripheral discoverCharacteristics:nil forService:s];
        ///
    }
}

//获取特征后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics){
        NSLog(@"c.properties:%lu",(unsigned long)c.properties) ;
        /// 写
        if ([c.UUID isEqual:[CBUUID UUIDWithString:myCharacteristicUUID]]) {
            [self.discoveredPeripheral setNotifyValue:YES forCharacteristic:c];
        }
        ///
        //Subscribing to a Characteristic’s Value 订阅
        [peripheral setNotifyValue:YES forCharacteristic:c];
        // read the characteristic’s value，回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:c];
        _writeCharacteristic = c;
        
    }
}

//订阅的特征值有新的数据时回调
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
    
//    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:myCharacteristicUUID]]) {
//        return;
//    }
//    // Notification has started
//    if (characteristic.isNotifying) {
//    NSLog(@"Notification began on %@", characteristic);
//    }
//    // Notification has stopped
//    else {
//    // so disconnect from the peripheral
//        NSLog(@"Notification stopped on %@. Disconnecting", characteristic);
//        [self.centralMgr cancelPeripheralConnection:peripheral];
//    }
    ///
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:myCharacteristicUUID]]){
        return;
    }
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    // Notification has stopped
    else {
    // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@. Disconnecting", characteristic);
        [self.centralMgr cancelPeripheralConnection:peripheral];
    }
    ///
    [peripheral readValueForCharacteristic:characteristic];
}

// 获取到特征的值时回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    _editText = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark 写数据
-(void)writeChar:(NSData *)data
{
    //回调didWriteValueForCharacteristic
    [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark 写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
}
///
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{

    NSLog(@"Peripheral Disconnected");
// We're disconnected, so start scanning again

    [self.centralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:myServicUUID]]
    options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}
///
#pragma mark 发送按钮点击事件
- (void)sendClick:(id)sender {
    // 字符串转Data
    NSData *data =[_editText dataUsingEncoding:NSUTF8StringEncoding];
    [self writeChar:data];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
