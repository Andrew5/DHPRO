//
//  BLEMainViewController.m
//  BLKApp
//
//  Created by Rillakkuma on 16/6/16.
//  Copyright © 2016年 TRY. All rights reserved.
//

#import "BLEMainViewController.h"
#import "DeveLoperViewController.h"
#import "MJRefresh.h"
#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"
@interface BLEMainViewController (){
        NSTimer *timer;
    int i;
}
//@property (strong, nonatomic) CBPeripheral *peripheral;
//@property (nonatomic, assign, readwrite) UInt32 deviceId;
//@property (nonatomic, assign, readwrite) UInt32 devicePassword;
//@property (strong, nonatomic) NSMutableArray *rssi_container;

@property (strong, nonatomic) DHBle *sensor;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property (nonatomic,strong)NSMutableArray *peripheralViewControllerArray;
//@property (nonatomic, assign, readwrite) UInt32 devicePassword;
//@property (strong, nonatomic) CBPeripheral *peripheral;
//@property (nonatomic, assign, readwrite) UInt32 deviceId;
@end

@implementation BLEMainViewController
//Byte autoOpen = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    i = 1;
    _sensor = [[DHBle alloc] init];
    [_sensor bleInit];
    _sensor.delegate = self;
    _peripheralViewControllerArray = [[NSMutableArray alloc] init];

   timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];
    //添加下啦刷新
    _tableViewMy.headerPullToRefreshText = @"下来刷新最新数据";
    _tableViewMy.headerReleaseToRefreshText = @"松开立即刷新";
    _tableViewMy.headerRefreshingText = @"正在龟速刷新";
    __weak BLEMainViewController * collVC = self;
    
    [_tableViewMy addHeaderWithCallback:^{
        [collVC scanTimer];
        [_tableViewMy headerEndRefreshing];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)scanTimer{
    if ([_sensor activePeripheral]) {
        if (_sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [_sensor.manager cancelPeripheralConnection:_sensor.activePeripheral];
            _sensor.activePeripheral = nil;
        }
    }
    i++;
    if ([_sensor peripherals]) {
        _sensor.peripherals = nil;
        [_peripheralViewControllerArray removeAllObjects];
        [_tableViewMy reloadData];
    }
    
    _sensor.delegate = self;
    printf("now we are searching device...\n");

    [_sensor scanDevice:5];
    NSLog(@"计数器 %i",i);
}

-(void) scanDeviceEndCallBack{
    
}

//发现设备返回
-(void)disconnectDeviceCallBack
{
    NSLog(@"OK+LOST");
}
-(void) scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level
{
    DeveLoperViewController *controller = [[DeveLoperViewController alloc] init];
    controller.peripheral = peripheral;
    if (controller.peripheral.name) {
        [timer invalidate];
    }
    controller.sensor = _sensor;
    [_peripheralViewControllerArray addObject:controller];
    [_tableViewMy reloadData];
    printf("信号强度 %d\r\n",level);
}
#pragma mark ——tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peripheralViewControllerArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    NSUInteger row = [indexPath row];
    DeveLoperViewController *controller = [_peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
//    cell.textLabel.text = [_sensor getDeviceName:_peripheral];
    cell.textLabel.text = peripheral.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:(NSString *), ...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    DeveLoperViewController *controller = [_peripheralViewControllerArray objectAtIndex:row];
    
    if (_sensor.activePeripheral && _sensor.activePeripheral != controller.peripheral) {
        [_sensor disconnectDevice:_sensor.activePeripheral];
    }
    
    _sensor.activePeripheral = controller.peripheral;
    [_sensor connectDevice:_sensor.activePeripheral];
    
    [self.navigationController pushViewController:controller animated:YES];
//    for (UITableView *table in self.view.subviews) {
//        if ([table isKindOfClass:[UITableView class]]) {
//            table.hidden = YES;
//            [table removeFromSuperview];
//        }
//    }
//    _tableViewMy.hidden = YES;
}


//连接信息
//-(void)connectDeviceCallBack:(Byte)result
//{
//    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )_sensor.activePeripheral.identifier);
//    NSLog(@"%@",(__bridge NSString*)s);
//}
//-(void) didDiscoverServicesCallBack:(DHBleResultType)result{
//    if(result == DHBLE_RESULT_OK){
//        NSLog(@"Service OK");
//    }
//    else{
//        NSLog(@"Service NG");
//
//    }
//}
//- (IBAction)lockGo:(UIButton *)sender {
//
//    if (sender.selected) {
//        sender.backgroundColor = [UIColor lightGrayColor];
//
//    }else{
//        sender.backgroundColor = [UIColor colorWithRed:0.106 green:0.671 blue:0.651 alpha:1.000];
//
//    }
//    sender.selected = !sender.selected;
//    
//    
//    if ([_sensor activePeripheral]) {
//        if (_sensor.activePeripheral.state == CBPeripheralStateConnected) {
//            [_sensor.manager cancelPeripheralConnection:_sensor.activePeripheral];
//            _sensor.activePeripheral = nil;
//        }
//    }
//    
//    if ([_sensor peripherals]) {
//        _sensor.peripherals = nil;
//
//    }
//    
//    printf("now we are searching device...\n");
//    [_sensor scanDevice:5];
//
//}

//- (void)SendOpenDoor{
//    // [self setDevicePassword:0x12345678];
//    if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
//        [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
//        /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 userId:0x11223344];*/
//    }
//    else{
//        //[self.navigationController popViewControllerAnimated:YES];
//        _sensor.activePeripheral = _peripheral;
//        [self.sensor connectDevice:_sensor.activePeripheral];
//    }
//}
//
//-(void) didDiscoverCharacteristicsCallBack:(DHBleResultType)result{
//    if(result == DHBLE_RESULT_OK){
//        NSString *value = [NSString stringWithFormat:@"Charact OK"];
//        NSLog(@"%@",value);
//        if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
//            if(autoOpen == 1){
//                [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
//                /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral]  devicePassword:0x12345678 userId:0x11223344];
//                 autoOpen = 0;*/
//            }
//        }
//        else{
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//    else{
//        NSLog(@"Charact NG");
//
//    }
//}
//- (void)readDeviceInfoCallBack:(DHBleResultType)result device:(UInt32)deviceId configStatus:(Byte)status{
//    if(result != DHBLE_ER_OK)
//    {
//        NSLog(@"Read DeviceInfo Error");
//    }
//    else{
//        NSString *value = [NSString stringWithFormat:@"Id:%d", deviceId];
//        NSLog(@"%@",value);
//        [self setDeviceId:deviceId];
//    }
//}

//#pragma mark - BLKAppSensorDelegate
//-(void)sensorReady
//{
    ///TODO: it seems useless right now.
//}
//
//-(void) scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level
//{
//        printf("level %d\r\n",level);
//}
//





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//
//-(void)connectDeviceCallBack:(Byte)result
//{
//    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )_sensor.activePeripheral.identifier);
//    NSLog(@"%@",(__bridge NSString*)s);
//    
//}
//-(void) didDiscoverServicesCallBack:(DHBleResultType)result{
//    if(result == DHBLE_RESULT_OK){
////        tvRecv.text= [tvRecv.text stringByAppendingString:@"Service OK"];
//    }
//    else{
////        tvRecv.text= [tvRecv.text stringByAppendingString:@"Service NG"];
//    }
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
