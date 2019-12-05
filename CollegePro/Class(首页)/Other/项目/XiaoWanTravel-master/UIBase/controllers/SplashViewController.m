//
//  SplashViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "SplashViewController.h"
#import "ADView.h"
#import "CommonDefin.h"

#import "AppDelegate.h"
#import "RootViewController.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isFisrtStarApp]) {
        [self showGuide];
    }else{
        [self goMain];
    }
}
//展示引导图（做启动动画）
-(void)showGuide{
    NSArray *array = @[@"guide_640_1136_01",@"guide_640_1136_02",@"guide_640_1136_03"];
    ADView *adView = [[ADView alloc]initWithArray:array andFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andBlock:^{
        [self goMain];
    }];
    [self.view addSubview:adView];
}
-(void)goMain
{
    RootViewController *root = [[RootViewController alloc]init];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = root;
}
//判断是否第一次启动程序
-(BOOL)isFisrtStarApp{
    //获得单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //读取次数（用户上一次启动app的次数）
    NSString *number = [userDefaults objectForKey:kAppFirstLoadKey];
    //判断是否有值
    if (number!=nil) {
        //能够取到值，则不是第一次启动
        NSInteger starNumer = [number integerValue];
        //用上一次的次数+1次
        NSString *str = [NSString stringWithFormat:@"%ld",++starNumer];
        //存的是用户这一次启动的次数
        [userDefaults setObject:str forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return NO;
    }else{
        //不能取到值，则是第一次启动
        NSLog(@"用户是第一次启动");
        [userDefaults setObject:@"1" forKey:kAppFirstLoadKey];
        [userDefaults synchronize];
        return YES;
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
