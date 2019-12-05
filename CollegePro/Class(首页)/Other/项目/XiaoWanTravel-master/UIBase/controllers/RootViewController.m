//
//  RootViewController.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "RootViewController.h"
#import "XiaoNavigationController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
  
}

-(void)createViewControllers
{
    NSArray *vcNameArray = @[@"TravailViewController",@"DistinationViewController",@"CommunityViewController",@"MyViewController"];
    
    NSArray *nameArray = @[@"Sidebar-index@2x",@"Sidebar-map@2x",@"Sidebar-photo-stream@2x",@"Sidebar-mine@2x"];
    
    NSArray *clickNameArray = @[@"Sidebar-index-hold@2x",@"Sidebar-map-hold@2x",@"Sidebar-photo-stream-hold@2x",@"Sidebar-mine-hold@2x"];
    
    NSArray *titleArray = @[@"首页",@"目的地",@"游行",@"我的"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (int i=0; i<vcNameArray.count; i++)
    {
        NSString *vcName = [vcNameArray objectAtIndex:i];
        
        Class vcClass = NSClassFromString(vcName);
        
        UIViewController *vc = [[vcClass alloc]init];
        
        //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        XiaoNavigationController *nav = [[XiaoNavigationController alloc]initWithRootViewController:vc];
        
        [array addObject:nav];
        
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArray[i] image:[[UIImage imageNamed:nameArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:clickNameArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:53/255.0f green:123/255.0f blue:240/255.0f alpha:1], NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateSelected];
        
    }
    self.tabBar.translucent = NO;
    //改变Tabbar的下面一行颜色
    self.tabBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zu"]];
    
    self.viewControllers = array;
    
    self.selectedIndex = 0;
    

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
