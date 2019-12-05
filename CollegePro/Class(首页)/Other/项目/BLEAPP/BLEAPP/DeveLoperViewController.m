//
//  DeveLoperViewController.m
//  BLEAPP
//
//  Created by Rillakkuma on 16/6/16.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "DeveLoperViewController.h"
#import "InfiniteRollScrollView.h"
#import "ImageModel.h"
@interface DeveLoperViewController ()<infiniteRollScrollViewDelegate>

@end

@implementation DeveLoperViewController
Byte autoOpen = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"芝麻开门";

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 20, 22);
    [leftBtn setImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(4,17,5,19)];
    [leftBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBarBtnItem;

    
    self.sensor.delegate = self;
    [self setDevicePassword:0x12345678];
    autoOpen = 1;
    _peripheral =_sensor.activePeripheral;
    
    
    _buttonLock.layer.borderWidth = 1;
    _buttonLock.layer.borderColor = [[UIColor grayColor] CGColor];
    _buttonLock.layer.cornerRadius = 50;
    _buttonLock.layer.masksToBounds = YES;
    
    
    
    InfiniteRollScrollView *scrollView = [[InfiniteRollScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight-300);
    scrollView.delegate = self;
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //需要显示的所有图片
    scrollView.imageArray = @[
                              [UIImage imageNamed:@"0.jpg"],
                              [UIImage imageNamed:@"1.jpg"],
                              [UIImage imageNamed:@"2.jpg"],
                              [UIImage imageNamed:@"3.jpg"],
                              [UIImage imageNamed:@"4.jpg"]
                              ];
    //需要显示的所有图片对应的信息，这里我们是手动添加的每张图片的信息，实际环境一般都是由服务器返回，我们再封装到model里面。
    scrollView.imageModelInfoArray = [NSMutableArray array];
    for (int i = 0; i<5; i++) {
        ImageModel *mode = [[ImageModel alloc]init];
        mode.name = [NSString stringWithFormat:@"picture-%zd",i];
        mode.url = [NSString stringWithFormat:@"http://www.baidu.com-%zd",i];
        [scrollView.imageModelInfoArray addObject:mode];
    }
    
    [self.view addSubview:scrollView];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//代理方法
-(void)infiniteRollScrollView:(InfiniteRollScrollView *)scrollView tapImageViewInfo:(id)info{
    ImageModel *model = (ImageModel *)info;
    NSLog(@"name:%@---url:%@", model.name, model.url);
}
- (void) scanDeviceEndCallBack{
    
}
-(void)connectDeviceCallBack:(Byte)result
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )_sensor.activePeripheral.identifier);
    NSLog(@"蓝牙设备编号--%@",(__bridge NSString*)s);

}
//发现服务调用
-(void) didDiscoverServicesCallBack:(DHBleResultType)result{
    if(result == DHBLE_RESULT_OK){
        NSLog(@"Service OK");
    }
    else{
        NSLog(@"Service NG");

    }
}

- (void) scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level{
    
}
//发现设备返回
-(void)disconnectDeviceCallBack
{
    NSLog(@"OK+LOST");
}
-(void) didDiscoverCharacteristicsCallBack:(DHBleResultType)result{
    if(result == DHBLE_RESULT_OK){
        NSString *value = [NSString stringWithFormat:@"Charact OK"];
        NSLog(@"%@",value);
        if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
            if(autoOpen == 1){
                [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
                /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral]  devicePassword:0x12345678 userId:0x11223344];
                 autoOpen = 0;*/
            }
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        NSLog(@"Charact NG");

    }
}
- (IBAction)SendOpenDoor:(UIButton *)sender{
    // [self setDevicePassword:0x12345678];
    if (sender.selected) {
        sender.backgroundColor = [UIColor lightGrayColor];
    }else{
        sender.backgroundColor = [UIColor colorWithRed:0.106 green:0.671 blue:0.651 alpha:1.000];
        if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
            [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
            /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 userId:0x11223344];*/
//            [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
            [_sensor oneKeyOpenDevice:_peripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678 openType:TYPE_OPEN_LOCK];
        }
        else{
            //[self.navigationController popViewControllerAnimated:YES];
            _sensor.activePeripheral = _peripheral;
            [self.sensor connectDevice:_sensor.activePeripheral];
        }

    }
    sender.selected = !sender.selected;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
