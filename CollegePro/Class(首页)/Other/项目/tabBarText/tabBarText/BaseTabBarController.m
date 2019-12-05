//
//  BaseTabBarController.m
//  tabBarText
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
#define UI_TAB_BAR_HEIGHT               49
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
//程序进去默认选择第几个tabar
#define DEFAULTSELECTINDEX 0
#define APPMAINCOLOR [UIColor colorWithRed:0.76 green:0.13 blue:0.25 alpha:1]
#define btn_tag 10001
#define WIDTH(v)                (v).frame.size.width
#import "BaseTabBarController.h"

#import "NTButton.h"

@implementation BaseTabBarController

static BaseTabBarController *sharedBaseTabBar;

+ (BaseTabBarController *)sharedBaseTabBarViewController {
    
    //	static dispatch_once_t onceToken;
    //	dispatch_once(&onceToken, ^{
    if (!sharedBaseTabBar) {
        sharedBaseTabBar = [[BaseTabBarController alloc] init];
        sharedBaseTabBar.view.backgroundColor = [UIColor redColor];
        NSLog(@"初始化");
    }
    //	});
    return sharedBaseTabBar;
}

+(BaseTabBarController *)destoryShared{
    return sharedBaseTabBar = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController * vc1 = [[UIViewController alloc] init];
    UIViewController * vc2 = [[UIViewController alloc] init];
    UIViewController * vc3 = [[UIViewController alloc] init];
    UIViewController * vc4 = [[UIViewController alloc] init];
    UIViewController * vc5 = [[UIViewController alloc] init];
    NSInteger tabNum = 5;
    NSArray *titleArr;
    self.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
    titleArr =@[@"",@"首页",@"发现",@"",@"消息",@"我的"];

    
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, UI_SCREEN_WIDTH, UI_TAB_BAR_HEIGHT)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    //去掉顶部的黑线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    UILabel *linel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0.1)];
    linel.backgroundColor = [UIColor blackColor];
    [_bgView addSubview:linel];
    [self.tabBar addSubview:_bgView];
    
    
    redView = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
    
    redView.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
    redView.layer.masksToBounds = YES;
    redView.layer.cornerRadius = 5;
    redView.hidden = YES;
    
    redView1 = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
    redView1.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
    redView1.layer.masksToBounds = YES;
    redView1.layer.cornerRadius = 5;
    redView1.hidden = YES;
    
    findRedView = [[UIView alloc]initWithFrame:CGRectMake(43, 4, 10, 10)];
    findRedView.backgroundColor = [UIColor colorWithRed:0.1 green:0.67 blue:1 alpha:1];
    findRedView.layer.masksToBounds = YES;
    findRedView.layer.cornerRadius = 5;
    findRedView.hidden = YES;
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(updateMessageCount) userInfo:nil repeats:YES];
//    _locationTimer =[NSTimer scheduledTimerWithTimeInterval:1800.0 target:self selector:@selector(getLocation) userInfo:nil repeats:YES];
    
    
           for (int i = 0; i < tabNum; i ++)
        {
            if (i!=2) {
                NTButton *button = [NTButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(i*UI_SCREEN_WIDTH/(tabNum),0,UI_SCREEN_WIDTH/(tabNum),UI_TAB_BAR_HEIGHT);
                button.enabled = i==DEFAULTSELECTINDEX?NO:YES;
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d",i+1]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected",i+1]] forState:UIControlStateDisabled];
                [button setTitle:titleArr[i+1] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [button setTitleColor:APPMAINCOLOR forState:UIControlStateDisabled];
                button.titleLabel.font =[UIFont systemFontOfSize:10];
                button.titleLabel.textAlignment =NSTextAlignmentCenter;
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbar%d_selected",i+1]] forState:UIControlStateDisabled];
                button.contentMode =UIViewContentModeCenter;
                button.clipsToBounds =YES;
                
                [button addTarget:self action:@selector(chooseTabBar:) forControlEvents:UIControlEventTouchUpInside];
                button.adjustsImageWhenHighlighted =NO;
                button.tag = btn_tag+i;
                if (!button.enabled){
                    [self setSelectedIndex:i];
                    _beforeIndex = i;
                    _presentIndex = i;
                }
                [_bgView addSubview:button];
                
                if (i ==1) {
                    [button addSubview:findRedView];
                }
                if (i==3) {
                    [button addSubview:redView];
                }
                if (i==4) {
                    [button addSubview:redView1];
                }
            }
        }
    
    centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.backgroundColor = [UIColor clearColor];
    [centerBtn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:0];
    centerBtn.frame = CGRectMake(2*UI_SCREEN_WIDTH/(tabNum),-40,UI_SCREEN_WIDTH/(tabNum),UI_TAB_BAR_HEIGHT+40);
    [centerBtn setTitle:@"预约" forState:UIControlStateNormal];
    [centerBtn setTitleColor:APPMAINCOLOR forState:UIControlStateDisabled];
    centerBtn.titleLabel.font =[UIFont systemFontOfSize:10];
    [centerBtn setTitleEdgeInsets:UIEdgeInsetsMake(70,-50,0, 0)];
    [centerBtn setImageEdgeInsets:UIEdgeInsetsMake(0,(WIDTH(centerBtn)-50)/2.0,0, 0)];
    [centerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [centerBtn addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:centerBtn];
 

}

-(void)centerClick{
    //发起预约
    UIViewController *dv = [UIViewController new];
    
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:dv] animated:YES completion:NULL];
}

-(void)chooseTabBar:(UIButton *)sender
{
    _presentIndex = sender.tag-btn_tag;
    [self confirmSelectTabBar:_presentIndex];
    [self setSelectedIndex:_presentIndex];
    _beforeIndex = _presentIndex;
}
-(void)confirmSelectTabBar:(NSInteger)selectIndex
{
    for (UIButton * button in [_bgView subviews]){
        if ([button isKindOfClass:[UIButton class]]){
            button.enabled= button.tag==selectIndex+10001?NO:YES;
        }
    }
}
@end
