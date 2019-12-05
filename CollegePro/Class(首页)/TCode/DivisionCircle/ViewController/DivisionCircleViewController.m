//
//  DivisionCircleViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/16.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DivisionCircleViewController.h"
#import "LJInstrumentView.h"

@interface DivisionCircleViewController ()
@property (strong,nonatomic)LJInstrumentView* checkMeter;

@end

@implementation DivisionCircleViewController

-(LJInstrumentView *)checkMeter{
    if (!_checkMeter) {
        _checkMeter=[[LJInstrumentView   alloc]initWithFrame:CGRectMake(50,50, 300, 300)];
        _checkMeter.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_checkMeter];
    }
    return _checkMeter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    self.checkMeter.timeInterval=0.3;
    //弧线
    [_checkMeter drawArcWithStartAngle:-M_PI*5/4 endAngle:M_PI/4 lineWidth:10.0f fillColor:[UIColor clearColor] strokeColor:[UIColor grayColor]];
    // 计时器
    _checkMeter.speedValue = 50;
    [NSTimer scheduledTimerWithTimeInterval:_checkMeter.timeInterval target:_checkMeter selector:@selector(runSpeedProgress) userInfo:nil repeats:NO];
    
    // 增加刻度值
    [_checkMeter DrawScaleValueWithDivide:1];
    // 进度的曲线
    [_checkMeter drawProgressCicrleWithfillColor:[UIColor clearColor] strokeColor:[UIColor whiteColor]];
    [_checkMeter setColorGrad:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:2.0/255 green:186.0/255 blue:197.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:44.0/255 green:203.0/255 blue:112.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:254.0/255 green:136.0/255 blue:5.0/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:247.0/255 green:21.0/255 blue:47.0/255 alpha:1.0] CGColor],nil]];
    //刻度
    [_checkMeter drawScaleWithDivide:100 andRemainder:5 strokeColor:[UIColor orangeColor] filleColor:[UIColor clearColor]scaleLineNormalWidth:5 scaleLineBigWidth:10];
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
