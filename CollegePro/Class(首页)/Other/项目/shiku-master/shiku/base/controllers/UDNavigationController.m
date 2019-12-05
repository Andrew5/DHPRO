//
//  UDNavigationController.m
//  test
//
//  Created by UDi on 15-1-7.
//  Copyright (c) 2015年 Mango Media Network Co.,Ltd. All rights reserved.
//

#import "UDNavigationController.h"

@implementation UDNavigationController
@synthesize alphaView;
-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        CGRect frame = self.navigationBar.frame;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        alphaView.backgroundColor = RGBCOLORV(0X7A9C5C);//[UIColor redColor];//MAIN_COLOR;
        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}
-(void)setAlph:(double)value{
    [UIView animateWithDuration:0.5 animations:^{
        alphaView.alpha = value;
    } completion:^(BOOL finished) {
        _changing = NO;
        
    }];
//    if (_changing == NO) {
//        _changing = YES;
//        if (alphaView.alpha == 0.0 ) {
//            [UIView animateWithDuration:0.5 animations:^{
//                alphaView.alpha = 0.8;
//            } completion:^(BOOL finished) {
//                 _changing = NO;
//            }];
//        }else{
//            [UIView animateWithDuration:0.5 animations:^{
//                alphaView.alpha = value;
//            } completion:^(BOOL finished) {
//                _changing = NO;
//
//            }];
//        }
//    }
//    
    
}

@end
