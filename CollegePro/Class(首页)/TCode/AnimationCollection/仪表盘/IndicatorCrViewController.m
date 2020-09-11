//
//  IndicatorCrViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/28.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "IndicatorCrViewController.h"

#import "indicatorCrView.h"
#import "RectangleIndicatorView.h"
@interface IndicatorCrViewController ()
@property (strong, nonatomic) indicatorCrView *circleIndicatorView;
@property (strong, nonatomic) RectangleIndicatorView *rectangleIndicatorView;

@end

@implementation IndicatorCrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"闪动" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(circleIndicatorShine) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(DH_DeviceWidth-50, 70, 31, 30);
    [self.view addSubview:btn1];
    btn1.layer.borderColor = [UIColor greenColor].CGColor;
    btn1.layer.borderWidth = 1.0;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"闪动" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(rectangleIndicatorShine) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(DH_DeviceWidth-50, 300, 31, 30);
    [self.view addSubview:btn2];
    btn2.layer.borderColor = [UIColor greenColor].CGColor;
    btn2.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view.self.rectangleIndicatorView.minValue = 40;
    __weak typeof(self) weakSelf = self;
    self.circleIndicatorView = [[indicatorCrView alloc]init];
    self.circleIndicatorView.frame = CGRectMake(0, 64, 375, 294);
    self.rectangleIndicatorView = [[RectangleIndicatorView alloc]init];
    self.rectangleIndicatorView.frame = CGRectMake(0, 350, 375, 294);
    self.rectangleIndicatorView.maxValue = 80;
    self.rectangleIndicatorView.valueToShowArray = @[@40, @50, @60, @70, @80];
    self.rectangleIndicatorView.indicatorValue = 50;
    self.rectangleIndicatorView.minusBlock = ^{
        NSLog(@"点击了 -");
        weakSelf.rectangleIndicatorView.indicatorValue -= 1;
    };
    self.rectangleIndicatorView.addBlock = ^{
        NSLog(@"点击了 +");
        weakSelf.rectangleIndicatorView.indicatorValue += 1;
    };
    
    self.circleIndicatorView.minValue = 40;
    self.circleIndicatorView.maxValue = 80;
    self.circleIndicatorView.innerAnnulusValueToShowArray = @[@40, @50, @60, @70, @80];
    self.circleIndicatorView.indicatorValue = 60;
    self.circleIndicatorView.minusBlock = ^{
        NSLog(@"点击了 -");
        weakSelf.circleIndicatorView.indicatorValue -= 1;
    };
    self.circleIndicatorView.addBlock = ^{
        NSLog(@"点击了 +");
        weakSelf.circleIndicatorView.indicatorValue += 1;
    };
    [self.view addSubview:self.circleIndicatorView];
    [self.view addSubview:self.rectangleIndicatorView];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self shineIndicatorView];
}

- (void)shineIndicatorView {
    [self.circleIndicatorView shineWithTimeInterval:0.01 pauseDuration:0 finalValue:70 finishBlock:^{
        //NSLog(@"---------- 执行完毕");
    }];
}

- (void)circleIndicatorShine {
    [self.circleIndicatorView shineWithTimeInterval:0.01 pauseDuration:0 finalValue:70 finishBlock:^{
        //NSLog(@"---------- 执行完毕");
    }];
}

- (void)rectangleIndicatorShine {
    [self.rectangleIndicatorView shineWithTimeInterval:0.01 pauseDuration:0 finalValue:50 finishBlock:^{
        //NSLog(@"---------- 执行完毕");
    }];
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
