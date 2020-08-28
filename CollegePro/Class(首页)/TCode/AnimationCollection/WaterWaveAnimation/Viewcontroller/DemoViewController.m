//
//  DemoViewController.m
//  LXWaveProgressDemo
//
//  Created by liuxin on 16/8/1.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import "DemoViewController.h"
#import "LXWaveProgressView.h"


@interface DemoViewController ()
@property (nonatomic,strong)LXWaveProgressView *progressView;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.progressView = [[LXWaveProgressView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    self.progressView.backgroundColor = [UIColor colorWithRed:168/255.0 green:1/255.0 blue:1/255.0 alpha:1];
//    self.progressView.center=CGPointMake(CGRectGetMidX(self.view.bounds), 150);
    self.progressView.progress = 0.5;
    self.progressView.waveHeight = 10;
    self.progressView.speed = 2;
    [self.view addSubview:self.progressView];
    
}
#pragma mark - system watches

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@  dealloc",NSStringFromClass(self.class));
#endif
}

@end
