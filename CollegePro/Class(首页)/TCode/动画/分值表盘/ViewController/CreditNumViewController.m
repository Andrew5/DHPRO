//
//  CreditNumViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/27.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CreditNumViewController.h"
#import "CreditNumView.h"
@interface CreditNumViewController ()
@property (nonatomic, strong) CreditNumView *m_CreditNumView;

@end

@implementation CreditNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.m_CreditNumView];
    
    // 根据需要调用
    self.m_CreditNumView.m_CreditNum = @"600";
    self.m_CreditNumView.m_CreditTime = @"2018-07-16";
    // Do any additional setup after loading the view.
}
- (CreditNumView *)m_CreditNumView
{
    if (!_m_CreditNumView) {
        _m_CreditNumView = [[CreditNumView alloc] initWithFrame:CGRectMake(0, 100, DH_DeviceWidth, DH_DeviceHeight - 100)];
    }
    
    return _m_CreditNumView;
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
