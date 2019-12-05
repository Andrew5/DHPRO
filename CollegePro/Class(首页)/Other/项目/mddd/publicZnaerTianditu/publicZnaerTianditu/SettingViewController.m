//
//  SettingViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/23.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "SettingViewController.h"
 

@interface SettingViewController ()

@end

@implementation SettingViewController

-(void)loadView{
    [super loadView];
    
    self.settingView = [[SettingView alloc]initWithController:self];
    
    self.view = self.settingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"设置"];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
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
