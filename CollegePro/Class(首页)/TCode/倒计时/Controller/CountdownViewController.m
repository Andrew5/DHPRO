//
//  CountdownViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/13.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "CountdownViewController.h"
#import "UIButton+ImageTitleSpacing.h"

@interface CountdownViewController ()
{
	 __block dispatch_source_t _timer;
}

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
//
@property (strong,nonatomic)dispatch_source_t sourceTimer;
@property (strong,nonatomic)NSTimer *timerrr;
@end

@implementation CountdownViewController
/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
-(NSString *)getyyyymmdd{
	NSDate *now = [NSDate date];
	NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
	formatDay.dateFormat = @"yyyy-MM-dd";
	NSString *dayStr = [formatDay stringFromDate:now];
	
	return dayStr;
	
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    dispatch_source_cancel(self.sourceTimer);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGFloat buttonH  = 62.0 + 14.0 + 12.0;//按钮高+间距+字体高度
    CGFloat buttonW  = 62.0;
    //安装子控制视图
    UIButton *buttonHangup = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonHangup setFrame:CGRectMake(36.0 ,[UIScreen mainScreen].bounds.size.height-buttonH-40 ,buttonW ,buttonH)];
    [buttonHangup setImage:[UIImage imageNamed:@"kefu"] forState:UIControlStateNormal];
    [buttonHangup setTitle:@"挂断" forState:UIControlStateNormal];
    [buttonHangup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buttonHangup.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 12];
    [buttonHangup layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:14.0];
    [self.view addSubview:buttonHangup];
    
    
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	NSDate *endDate = [dateFormatter dateFromString:@"2020-01-24"];
	NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24*3600)];
	NSDate *startDate = [NSDate date];
	NSTimeInterval timeInterval =[endDate_tomorrow timeIntervalSinceDate:startDate];
    

    if (_timer==nil) {
		__block int timeout = timeInterval; //倒计时时间
		
		if (timeout!=0) {
			dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
			_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
			dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
			dispatch_source_set_event_handler(_timer, ^{
				if(timeout<=0){ //倒计时结束，关闭
					dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
					dispatch_async(dispatch_get_main_queue(), ^{
						self.dayLabel.text = @"";
						self.hourLabel.text = @"00";
						self.minuteLabel.text = @"00";
						self.secondLabel.text = @"00";
					});
				}else{
					int days = (int)(timeout/(3600*24));
					if (days==0) {
						self.dayLabel.text = @"";
					}
					int hours = (int)((timeout-days*24*3600)/3600);
					int minute = (int)(timeout-days*24*3600-hours*3600)/60;
					int second = timeout-days*24*3600-hours*3600-minute*60;
					dispatch_async(dispatch_get_main_queue(), ^{
						if (days==0) {
							self.dayLabel.text = @"0天";
						}else{
							self.dayLabel.text = [NSString stringWithFormat:@"%d天",days];
						}
						if (hours<10) {
							self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
						}else{
							self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
						}
						if (minute<10) {
							self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
						}else{
							self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
						}
						if (second<10) {
							self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
						}else{
							self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
						}
						
					});
					timeout--;
				}
			});
			dispatch_resume(_timer);
		}
	}
    //创建时间计时器
    [self createTime];
    [self createTimer];
    // Do any additional setup after loading the view from its nib.
}
- (void)createTime{
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //使用全局队列创建计时器
    _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //定时器延迟时间
    __block NSTimeInterval delayTime = 00.00f;
    
    //定时器间隔时间
    NSTimeInterval timeInterval = 1.0f;
    
    //设置开始时间
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    
    //设置计时器
    dispatch_source_set_timer(_sourceTimer,startDelayTime,timeInterval*NSEC_PER_SEC,0.01*NSEC_PER_SEC);
//    dispatch_source_set_timer(_sourceTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行

    DH_WEAKSELF;
    //执行事件
    dispatch_source_set_event_handler(_sourceTimer,^{
        delayTime ++;
        int days = (int)(delayTime/(3600*24));
        int hours = (int)((delayTime-days*24*3600)/3600);
        int minute = (int)(delayTime-days*24*3600-hours*3600)/60;
        int second = delayTime-days*24*3600-hours*3600-minute*60;
        NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
        if (delayTime == 22) {
            //销毁定时器
            dispatch_source_cancel(weakSelf.sourceTimer);
        }
//        if (days==0) {
//            NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
//        }
//        else if (hours>24) {
//            NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
//        }
//        else if (minute<60) {
//            NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
//        }
//        else if (second<3600) {
//            NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
//        }else{
//            NSLog(@"定时器 --- %@--%.2f--天-%d天:%d小时:%.2d分:%.2d秒",weakSelf.sourceTimer,delayTime,days,hours,minute,second);
//        }

    });
    
    //启动计时器
    dispatch_resume(_sourceTimer);
}
//NSTimer
-(void)createTimer{
    
    //初始化
    //_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //执行操作
    //}];
    
//    self.timerrr = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timerrr forMode:NSDefaultRunLoopMode];

    self.timerrr = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    //加入runloop循环池
    [[NSRunLoop mainRunLoop] addTimer:self.timerrr forMode:NSDefaultRunLoopMode];
    
    //开启定时器
    [self.timerrr fire];
}
-(void)timerStart:(NSTimer *)timer{
    NSLog(@"%s--NSTimer---%.2lf",__func__,self.timerrr.timeInterval);
    if (self.timerrr.timeInterval>20)
    {
        //销毁定时器
        [self.timerrr invalidate];
        self.timerrr = nil;
    }

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
