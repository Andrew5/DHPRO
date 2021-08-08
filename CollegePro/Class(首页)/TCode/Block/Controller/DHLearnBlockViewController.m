//
//  DHLearnBlockViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/7/31.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "DHLearnBlockViewController.h"

@interface DHLearnBlockViewController ()

@end

@implementation DHLearnBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)b{
    void (^ MtTestBlock)(int,int)=^(int a,int b){
        int v= a+b;
        NSLog(@"本地传值内容:%d",v);
    };
    MtTestBlock(10,20);
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
