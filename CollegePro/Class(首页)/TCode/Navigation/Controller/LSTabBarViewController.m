//
//  LSTabBarViewController.m
//  Gongzuo
//
//  Created by hanyegang on 16/1/7.
//  Copyright (c) 2016年 hanyegang. All rights reserved.
//

#import "LSTabBarViewController.h"
#import "AutoLayoutViewController.h"
#import "ReleaseViewController.h"
#import "DetailsDrawViewController.h"
#import "YSYPreviewViewController.h"
#import "TkTabBar.h"
#import "UIImage+Extend.h"

@interface LSTabBarViewController ()
@property (nonatomic,strong)TkTabBar *tabBar;

@end

@implementation LSTabBarViewController
@dynamic tabBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTabBar];
}

- (void)setTabBar
{
	
//    TkTabBar *tabBar = [[TkTabBar alloc]initWithFrame:self.tabBar.frame];
//    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [UIImage new];

    if(@available(iOS 13.0, *)){
        UITabBarAppearance* tabbarAppearance =self.tabBar.standardAppearance; tabbarAppearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:(CGSizeZero)];
        tabbarAppearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor] size:(CGSizeZero)];
        self.tabBar.standardAppearance = tabbarAppearance;
    }
    
    AutoLayoutViewController *InforVC = [[AutoLayoutViewController alloc] init];
    [self setupChildViewController:InforVC title:@"消息" imageName:@"TabbarBundle.bundle/tabbar_mainframe" selectedImageName:@"TabbarBundle.bundle/tabbar_mainframeHL"];
	
    ReleaseViewController *BrandVC = [[ReleaseViewController alloc] init];
    [self setupChildViewController:BrandVC title:@"品牌" imageName:@"soul3" selectedImageName:@"soul33"];

//    UIStoryboard *work = [UIStoryboard storyboardWithName:@"WorkRoot" bundle:nil];
//    WorkRootViewController *workVC = [work instantiateViewControllerWithIdentifier:@"WorkRootViewController"];
    DetailsDrawViewController *details = [[DetailsDrawViewController alloc] init];
    [self setupChildViewController:details title:@"工作" imageName:@"soul2" selectedImageName:@"soul22"];
    
    YSYPreviewViewController *MyVC = [[YSYPreviewViewController alloc] init];
    [self setupChildViewController:MyVC title:@"我的" imageName:@"SettingN" selectedImageName:@"SettingS"];
	
	PostTableViewController*PostVC = [[PostTableViewController alloc] init];
	[self setupChildViewController:PostVC title:@"设置" imageName:@"SettingN" selectedImageName:@"SettingS"];
    
}
- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:childVC];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor greenColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    // 设置标题属性
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
//    [Nav.navigationBar setTitleTextAttributes:textAttrs];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSDictionary *dicSelect = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.0],NSForegroundColorAttributeName:[UIColor blackColor]};
    [Nav.tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [Nav.tabBarItem setTitleTextAttributes:dicSelect forState:UIControlStateSelected];

    [self addChildViewController:Nav];
    
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
