//
//  AutoScrollerViewController.m
//  TestDemo
//
//  Created by jabraknight on 2021/1/3.
//  Copyright © 2021 张晓磊. All rights reserved.
//

#import "AutoScrollerViewController.h"
#import "GradientView.h"

@interface AutoScrollerViewController ()
{
    UIImageView *autoScrollerView,*autoScrollerView2;
    int flag;
    NSTimer *timerCu;

}
@property (nonatomic, assign) CFRunLoopTimerRef timer;
@property (nonatomic,assign) NSTimeInterval timeinterval;

@end

@implementation AutoScrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self gradientViewMethod];
}
- (void)gradientViewMethod{
    //1、
    autoScrollerView = [[UIImageView alloc]init];
    [autoScrollerView setImage:[UIImage imageNamed:@"imageMain"]];
    [self.view addSubview:autoScrollerView];
    autoScrollerView.frame = CGRectMake(0, 0, 100, [UIScreen mainScreen].bounds.size.height);
    //2、
    autoScrollerView2 = [[UIImageView alloc]init];
    [autoScrollerView2 setImage:[UIImage imageNamed:@"imageMain"]];
    [self.view addSubview:autoScrollerView2];
    autoScrollerView2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 100, [UIScreen mainScreen].bounds.size.height);
    
    self.timeinterval = 0.01;
    [self cofigTimer];
    
    GradientView *view = [[GradientView alloc]initWithFrame:self.view.frame];
    view.startColor = [UIColor whiteColor];
    view.endColor = [UIColor orangeColor];
    view.gradientViewType = 1;
    view.alpha = 0.5;
    [self.view addSubview:view];
}
- (void)scro{
    __weak typeof(self)weakSelf = self;

    [UIView animateWithDuration:0.1 animations:^{
        CGFloat Y = self->flag--;
        CGRect frame = self->autoScrollerView.frame;
        frame.origin.y = Y;
        self->autoScrollerView.frame = frame;
        [self->autoScrollerView layoutIfNeeded];
        NSLog(@"输出%.2f---%.2f",Y,self->autoScrollerView.frame.origin.y);
        if (fabs(self->autoScrollerView.frame.origin.y) >= 40) {
            //            [weakSelf pauseTimer];
            CGFloat Y = 0;
            CGRect frame = self->autoScrollerView.frame;
            frame.origin.y = Y;
            self->autoScrollerView.frame = frame;
            [self->autoScrollerView layoutIfNeeded];
        }
    }];
}
- (void)cofigTimer{
    if (self.timer)
       {
           CFRunLoopTimerInvalidate(self.timer);
           CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
       }
       __weak typeof(self)weakSelf = self;
       CFRunLoopTimerRef time = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent()+ _timeinterval, _timeinterval, 0, 0, ^(CFRunLoopTimerRef timer) {
           [weakSelf scro];

       });
       self.timer  = time;
       CFRunLoopAddTimer(CFRunLoopGetCurrent(), time, kCFRunLoopCommonModes);
}
- (void)pauseTimer
{
    if (self.timer)
    {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
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
