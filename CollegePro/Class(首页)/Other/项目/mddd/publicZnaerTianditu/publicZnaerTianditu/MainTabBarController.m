//
//  MainTabBarController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "MainTabBarController.h"
#import "BDMapViewController.h"
#import "ContactsViewController.h"
#import "SomeoneViewController.h"
#import "BaseNavigationController.h"
#import "WXHLGlobalUICommon.h"
#import "UIButton+UIButtonExt.h"
#import "FindViewController.h"

@implementation MainTabBarController
{
    UIView *_tabBarView;
    NSMutableArray *_tabbtnArray;
    
    BDMapViewController *mapVC ;
   ContactsViewController *contactsVC;

   FindViewController *findVC ;
    SomeoneViewController *someoneVC ;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];
    }
    return self;
}




-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initViewController];
    [self initTabBar];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
}

//初始化子视图控制器
-(void)initViewController{
    
    mapVC = [[BDMapViewController alloc]init];
   contactsVC = [[ContactsViewController alloc]init];
    contactsVC.valueDelegate = mapVC;
    
  
   findVC = [[FindViewController alloc]init];
    findVC.valueDelegate=mapVC;
    someoneVC = [[SomeoneViewController alloc]init];

    NSArray *vcs = @[mapVC,contactsVC,findVC,someoneVC];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:4];
    
    for (UIViewController *vc in vcs) {
        BaseNavigationController *naviVC = [[BaseNavigationController alloc]initWithRootViewController:vc];
        [viewControllers addObject:naviVC];
    }
    
    self.viewControllers = viewControllers;
}

//初始化分栏
-(void)initTabBar{
   
    CGRect bounds = WXHLApplicationBounds();

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, bounds.size.height - 49 - 20, bounds.size.width, 49)];

#else

    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, bounds.size.height - 49, bounds.size.width, 49)];

#endif
    
    
    [self.view addSubview:_tabBarView];
    
    CGFloat buttonW = _tabBarView.frame.size.width / 4;
    CGFloat buttonH = _tabBarView.frame.size.height;
    
    UIImage *norTabBarbg = [UIImage imageNamed:@"bottom_box_bg.png"];
    norTabBarbg = [norTabBarbg imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    UIImage *selTabBarbg = [UIImage imageNamed:@"bottom_box_sel_bg.png"];
    selTabBarbg = [selTabBarbg imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    
    _tabbtnArray = [NSMutableArray array];
    
    for (int i = 0; i < self.viewControllers.count; i ++) {
      
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(buttonW * i, 0, buttonW, buttonH);
        
        button.tag = i;
       
        switch (i) {
            case 0:{
                [button setTitle:@"地图" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_1.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_1_sel.png"] forState:UIControlStateSelected];
                button.selected = YES;
                break;
            }
            case 1:{
                [button setTitle:@"通讯录" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_2.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_2_sel.png"] forState:UIControlStateSelected];

                break;
            }
            case 2:{
                [button setTitle:@"查找" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_3.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_3_sel.png"] forState:UIControlStateSelected];
                
                break;
            }
            case 3:{
                [button setTitle:@"我" forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_4.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"bottom_icon_4_sel.png"] forState:UIControlStateSelected];
                break;
            }
                
            default:
                break;
        }
        
        [button setBackgroundImage:norTabBarbg forState:UIControlStateNormal];
        [button setBackgroundImage:selTabBarbg forState:UIControlStateSelected];
        [button setBackgroundImage:selTabBarbg forState:UIControlStateHighlighted];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];

        [button centerImageAndTitle:0.0f];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabBarView addSubview:button];
        [_tabbtnArray addObject:button];
    }

}


-(void)selectedTab:(UIButton *)button{
    
    self.selectedIndex = button.tag;
    
    for (UIButton *btnItem in _tabbtnArray) {
        if (btnItem.tag == button.tag)
            btnItem.selected = YES;
        else
            btnItem.selected = NO;
    }

}

-(void)hideTabBar{
    
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
 
    CGRect bounds = WXHLApplicationBounds();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    
    _tabBarView.frame = CGRectMake(-bounds.size.width, bounds.size.height - 49 - 20, bounds.size.width, 49);
    
#else
    
    _tabBarView.frame = CGRectMake(-bounds.size.width, bounds.size.height - 49, bounds.size.width, 49);
    
#endif
    [UIView commitAnimations];
    
}

-(void)showTabBar{
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    
    CGRect bounds = WXHLApplicationBounds();
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
    
    _tabBarView.frame = CGRectMake(0, bounds.size.height - 49 - 20, bounds.size.width, 49);
    
#else
    
    _tabBarView.frame = CGRectMake(0, bounds.size.height - 49, bounds.size.width, 49);
    
#endif
    [UIView commitAnimations];

}

-(void)backFirstVC{
    self.selectedIndex = 0;
    for (UIButton *btnItem in _tabbtnArray) {
        if (btnItem.tag == 0)
            btnItem.selected = YES;
        else
            btnItem.selected = NO;
    }
}

@end
