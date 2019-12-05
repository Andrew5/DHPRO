//
//  RoppleViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/14.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "RoppleViewController.h"
#import "RippleView.h"
@interface RoppleViewController ()

@end

@implementation RoppleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *circleA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    circleA.layer.cornerRadius = 75;
    circleA.backgroundColor = ColorWithAlpha(255, 216, 87, 1);
    circleA.center = CGPointMake(screenSize.width / 2, 50+150);
    
    RippleView *viewA = [[RippleView alloc] initWithFrame:CGRectMake(0, 0, 150, 150) animationType:AnimationTypeWithBackground];
    viewA.center = circleA.center;
    
    [self.view addSubview:viewA];
    [self.view addSubview:circleA];
    
    
    UIView *circleB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    circleB.layer.cornerRadius = 75;
    circleB.backgroundColor = ColorWithAlpha(255, 216, 87, 1);
    circleB.center = CGPointMake(screenSize.width / 2, screenSize.height - 50 - 150);
    
    RippleView *viewB = [[RippleView alloc] initWithFrame:CGRectMake(0, 0, 150, 150) animationType:AnimationTypeWithoutBackground];
    viewB.center = circleB.center;
    
    [self.view addSubview:viewB];
    [self.view addSubview:circleB];
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
