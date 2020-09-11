//
//  WKBaseVCViewController.m
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/4/18.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "WKBaseVC.h"

@interface WKBaseVC ()
@property (nonatomic, assign) BOOL oldNavBarHiddenState;
@property (nonatomic, assign) BOOL oldNavBarHidden;
@end

@implementation WKBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    // Do any additional setup after loading the view.


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _oldNavBarHiddenState = self.navigationController.navigationBarHidden;
    _oldNavBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    if (self.presentingViewController) {
        self.nav.backTitle = @"退出";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = _oldNavBarHidden;
    self.navigationController.navigationBarHidden = _oldNavBarHiddenState;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WKNavView *)nav
{
    if (!_nav) {
        _nav = [WKNavView new];
        _nav.delegate = self;
    }
    [self.view bringSubviewToFront:_nav];
    return _nav;
}



-(void)backItemClick
{
    if (self.navigationController) {
        
        if (self.navigationController.viewControllers.count <= 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
