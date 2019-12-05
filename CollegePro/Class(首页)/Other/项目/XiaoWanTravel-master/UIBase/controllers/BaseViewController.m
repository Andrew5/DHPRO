//
//  BaseViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)addTitleViewWithTitle:(NSString *)title
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.titleView = titleView;
    // 设置字体
    titleView.font = [UIFont systemFontOfSize:20];
    // 设置颜色
    titleView.textColor = [UIColor blackColor];
    // 设置文字居中
    titleView.textAlignment = NSTextAlignmentCenter;
    // 设置文本
    titleView.text = title;
    
    
}

- (void)addBarButtonItem:(NSString *)name image:(UIImage *)image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    // 设置按钮
    [button setTitle:name forState:UIControlStateNormal];
    // 设置图片
    [button setBackgroundImage:image forState:UIControlStateNormal];
    // 设置frame
    button.frame = CGRectMake(0, 0, 44, 30);
    
    // 判断是否放在左侧按钮
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    }
    else {
        self.navigationItem.rightBarButtonItem = item;
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
