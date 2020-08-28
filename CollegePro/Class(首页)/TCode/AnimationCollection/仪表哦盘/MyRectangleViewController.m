
//
//  MyRectangleViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/5.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "MyRectangleViewController.h"
#import "MyCreView.h"
@interface MyRectangleViewController ()
{
    UILabel *label;
    MyCreView *v;
}
@end

@implementation MyRectangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    v = [[MyCreView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    [v progress:57];
    [self.view addSubview:v];
    
    
    label  = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width-100)/2, v.bottom+10, 100, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.width-100)/2, label.bottom+10, 100, 50);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"点击" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
- (void)action:(UIButton*)sender{
    
    float value = arc4random()%+100;
    label.text = [NSString stringWithFormat:@"%0.1f",value];
    [v progress:value];
    
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
