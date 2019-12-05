//
//  BaseTabBarViewController.m
//  LBJH
//
//  Created by 创投天下 on 15/9/2.
//  Copyright (c) 2015年 cttx. All rights reserved.
//

#import "BaseTabBarViewController.h"

#import "BaseNavigationController.h"

#define DH_TitleKey      @"title"
#define DH_ClassKey      @"rootVCName"
#define DH_ImaeNormalKey @"imageNameNormal"
#define DH_ImaeSelectKey @"imageNameSelect"
#define DH_TitleColorKey @"titleColor"


@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
{
    UILabel *_redLab;
}

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myTabbar];
    // Do any additional setup after loading the view.
}
- (void)myTabbar
{  
 
	NSArray *dataArray = @[
						@{DH_ClassKey      : @"DHMainViewController",
						  DH_TitleKey      : @"消息",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_mainframe",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_mainframeHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHAdressViewController",
						  DH_TitleKey      : @"地址管理",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_contacts",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_contactsHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHWorkViewController",
						  DH_TitleKey      : @"工作",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_discover",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_discoverHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHMyInfoViewController",
						  DH_TitleKey      : @"我的",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_me",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_meHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  }
						];
	DH_WEAKSELF;
	[dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
		UIViewController *vc = [NSClassFromString(dict[DH_ClassKey]) new];
		vc.title = dict[DH_TitleKey];
		
		BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
		UITabBarItem *item = navi.tabBarItem;
		item.title = dict[DH_TitleKey];
		item.image = [UIImage imageNamed:dict[DH_ImaeNormalKey]];
		item.selectedImage = [[UIImage imageNamed:dict[DH_ImaeSelectKey]]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		[item setTitleTextAttributes:@{NSUnderlineColorAttributeName:dict[DH_TitleColorKey], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName : dict[DH_TitleColorKey]} forState:UIControlStateSelected];
		
		[weakSelf addChildViewController:navi];
	}];
	//显示第几个
	self.selectedIndex = 0;

}
//- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title backgroundColor:(UIColor *)color imageName:(NSString *)imageName selectedName:(NSString *)selectImageName
//{
//    childVC.navigationItem.title = title;
//    UIImage *image = [UIImage imageNamed:imageName];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    childVC.tabBarItem.image = image;
//    
//    UIImage *selectImage = [UIImage imageNamed:selectImageName];
//    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//   childVC.tabBarItem.selectedImage = selectImage;
//	
////    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 460-48,375, 48)] ;
////    [self.view addSubview:tabBarView];
////    //    UIImageView *backGroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_background.png"]];
////    tabBarView.backgroundColor = IWColor(255,155,0);    [tabBarView addSubview:tabBarView];
//
//    BaseNavigationController *childNav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName, nil] forState:(UIControlStateNormal)];
//    
////    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
////    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//    //背景色
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    [self addChildViewController:childNav];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end








