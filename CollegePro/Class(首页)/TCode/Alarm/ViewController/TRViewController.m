//
//  TRViewController.m
//  Alarm clock
//
//  Created by shupengstar on 16/4/11.
//  Copyright © 2016年 YJH. All rights reserved.
//

#import "TRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

//那你试试写一个闹钟，用户可以设定时间，到点了就响起用户选择好的铃声，一直响直到用户关闭闹钟
#define kW self.view.frame.size.width
#define kH self.view.frame.size.height


@interface TRViewController ()<UIApplicationDelegate>
{
    NSTimer * _timer;  //定时器
}
@property(nonatomic, weak)UIDatePicker * picker;
//@property(nonatomic,strong) UIAlertView * alert;
@property(nonatomic,weak) UILabel * label;

@property(nonatomic,assign)NSInteger lt;

@property(nonatomic,weak) UIButton * button;


@end

@implementation TRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"闹钟";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self loadsomeview];
    
  
//    UIApplication * app=[UIApplication sharedApplication];
//    app.delegate = self;
    // Do any additional setup after loading the view.
}
-(void)loadsomeview{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 20+45, kW, kH)];
    
    
    UIDatePicker * picker=[[UIDatePicker alloc]init];
    picker.frame = CGRectMake(0, 40, kW, 200);
    
    picker.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.5 alpha:0.1];
    
    [view addSubview:picker];
    
    _picker=picker;
    
    [self.view addSubview:view];
    
    
    UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake( 70, 340, 100, 40)];
    
    button.backgroundColor=[UIColor colorWithRed:0.1 green:0.5 blue:0.8 alpha:0.2];
    
//    button.center=self.view.center;
    
    [button setTitle:@"确定" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(countTime:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [button setTitle:@"确定" forState:UIControlStateSelected];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    
    
    _button=button;
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(190, 340, 100, 40)];
    btn.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.8 alpha:0.2];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(dismisTime:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    [self.view addSubview:button];
    
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(20, 400, kW-40, kH-400-80)];
    
    label.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.6 alpha:0.2];
    
    label.text=@"00:00:00";
    
    label.textAlignment=NSTextAlignmentCenter;
        
    _label=label;
    
    [self.view addSubview:label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(25, 400, kW-40, 40)];
    
    label1.text=@"闹钟还剩时间：";
    
    [self.view addSubview: label1];
}
- (void) dismisTime:(UIButton *) button{
    self.label.text = @"00:00:00";
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.timer setFireDate:[NSDate distantFuture]];
    [appDelegate.player stop];
    [_timer setFireDate:[NSDate distantFuture]];
    
}

- (void) countTime:(UIButton *) button

{
    
    _button =button;
    
    
    button.selected=!button.selected;
    
    NSDateFormatter * format1=[[NSDateFormatter alloc]init];
    
    [format1 setDateFormat:@"hh"];
    
    NSDateFormatter * format2=[[NSDateFormatter alloc]init];
    
    [format2 setDateFormat:@"mm"];
    
    //获取小时  选择数据（时间）
    NSInteger temp1 = 0;
    
    NSInteger temp2 = 0;
    
    NSString * str1=[format1 stringFromDate:_picker.date];
    
     temp1=[str1 integerValue];

    //本地数据
    NSDate * date3=[[NSDate alloc]init];
    
    NSString * str3=[format1 stringFromDate:date3];
    
    NSInteger temp3=[str3 integerValue];
    
    //获取分钟
    
    NSString * str2=[format2 stringFromDate:_picker.date];
    
    temp2= [str2 integerValue];
    
    
    NSDate * date4=[[NSDate alloc]init];
    
    NSString * str4=[format2 stringFromDate:date4];
    
    NSInteger temp4=[str4 integerValue];
    
    NSLog(@"闹钟时长：%li 秒",(temp1-temp3)*60*60+(temp2-temp4)*60);
    
    //--------------------------------------------------------------------
    
    self.num=(temp1-temp3)*60*60+(temp2-temp4)*60;
    
//    if (self.num != 0) {
//		[[NSNotificationCenter defaultCenter]postNotificationName:@"Alarm" object:nil userInfo:@{@"length":[NSNumber numberWithUnsignedInteger:self.num]}];
//
//
////    AppDelegate* app = [[AppDelegate alloc] init];
////    self.delegate = app;
////    if (self.delegate&&[self.delegate respondsToSelector:@selector(ViewControllerSendTime:)]) {
////        [self.delegate ViewControllerSendTime:self.num];
////    }
////    [self.delegate ViewControllerSendTime:self.num];
////
//    }
	
	
    _lt=self.num;
    
    if (_lt > _button.selected)
        
    {
        
        NSString * strT=[NSString stringWithFormat:@"%02i:%02i:%02i",(int)_lt/3600%60,(int)_lt/60%60,(int)_lt%60];
        
        _label.text=strT;
        
    }
    
    else
        
    {
        
        NSLog(@"请重新设置时间....");
        
        _label.text=@"00:00:00";
        
        return;
        
    }
    _timer = nil;
    if(_timer==nil)
        
    {
        
        //每隔1秒刷新一次页面
        
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantPast]];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        NSLog(@"开始倒计时.....");
        
    }
    
    else
        
    {
        //关闭
        [_timer setFireDate:[NSDate distantFuture]];
        
        //        [_timer invalidate];   //定时器失效
        
    }

    
}
- (void) runAction{
     _lt--;
    NSString * str=[NSString stringWithFormat:@"%02d:%02d:%02d",(int)(self.lt)/3600%24,(int)(self.lt)/60%60,(int)(self.lt)%60];
    
    _label.text=str;
    if (_lt == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Alarm" object:nil userInfo:@{@"length":[NSNumber numberWithUnsignedInteger:self.num]}];

//        self.alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"关闭闹钟" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//
//
//        self.alert.delegate=self;
//
//
//        [self.alert show];
        
        
    }
    NSLog(@"倒计时.....%ld",_lt);
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//
//{
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    [appDelegate.player stop];
//    [appDelegate.timer setFireDate:[NSDate distantFuture]];
//
//    [_player stop];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
