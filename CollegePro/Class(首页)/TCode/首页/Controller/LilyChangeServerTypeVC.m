//
//  LilyChangeServerTypeVC.m
//  LilyOnlineeducation
//
//  Created by Lilyzyf on 2020/7/12.
//  Copyright © 2020 Lilyenglish. All rights reserved.
//

#import "LilyChangeServerTypeVC.h"
#import "LilyServerTypeManger.h"
#import "AppDelegate.h"

//static LilyServerType SERVER_TYPE_DEFAULT = LilyServerTypeProduction;

#define  URLHOST [LilyServerTypeManger server]

@interface LilyChangeServerTypeVC ()
@property (strong, nonatomic) UISegmentedControl *seg;
@end

@implementation LilyChangeServerTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"环境切换";
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    NSArray *items = @[ @"本地环境",@"开发环境",@"测试环境",@"预发布环境",@"正式环境"];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
    self.seg = seg;
    [self.view addSubview:seg];
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(88+80);
        make.height.mas_equalTo(45);
    }];
    
    LilyServerType type = [LilyServerTypeManger getServerType];
    seg.selectedSegmentIndex = type - 1;
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"确 定" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"自读测评蓝色色按钮_ipad"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(seg.mas_bottom).offset(80);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(44);
    }];
    
}

- (void)sure:(UIButton *)btn
{
    //切换之前的值
    LilyServerType type = [LilyServerTypeManger getServerType];
    
    
    NSArray *serArr = @[@(LilyServerTypeLocation), @(LilyServerTypeDevelop), @(LilyServerTypeTest), @(LilyServerTypePreRelease), @(LilyServerTypeProduction)];
    //存储切换之后的值
    [LilyServerTypeManger setServerType:[serArr[self.seg.selectedSegmentIndex] integerValue]];
//    QQLog(@"%@", @([LilyServerTypeManger getServerType]));
    
    //切换后退出登录
    if (type != [LilyServerTypeManger getServerType]) {

         AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        NSMutableDictionary *parameter = [NSMutableDictionary new];
        parameter[@"viewController"] = appDelegate;

        //重新请求相应环境对应的加密串
//        [LILYAPI onHttpCode:kAPPSeparation WithParameters:parameter];
//        [LILYAPI onHttpCode:kAPPSecretkey WithParameters:parameter];


        [[NSNotificationCenter defaultCenter] postNotificationName:@"eLLToLoginViewController" object:@{@"eLLToLoginViewController" : @"1"}];
    }
    
    if (self.sureBlock) {
        self.sureBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
