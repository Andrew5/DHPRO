//
//  NetworkSpeedViewController.m
//  MyFirstOCUseSwiftDemo
//
//  Created by jabraknight on 2020/4/9.
//  Copyright © 2020 jabraknight. All rights reserved.
//
#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

#import "NetworkSpeedViewController.h"
#import "DDYNetworkSpeedTool.h"

@interface NetworkSpeedViewController ()
@property (nonatomic, strong) UIButton *measureButton;

@property (nonatomic, strong) UILabel *measureSpeedLabel;

@property (nonatomic, strong) UILabel *instantSpeedLabel;

@property (nonatomic, strong) DDYNetworkSpeedTool *netTool;

@end

@implementation NetworkSpeedViewController

- (UIButton *)measureButton {
    if (!_measureButton) {
        _measureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_measureButton setTitle:@"start measure speed" forState:UIControlStateNormal];
        [_measureButton setTitle:@"stop measure speed" forState:UIControlStateSelected];
        [_measureButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_measureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_measureButton setBackgroundColor:[UIColor lightGrayColor]];
        [_measureButton setFrame:CGRectMake(10, DDYTopH+90, DDYScreenW-20, 30)];
        [_measureButton addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _measureButton;
}

- (UILabel *)measureSpeedLabel {
    if (!_measureSpeedLabel) {
        _measureSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, DDYTopH+10, DDYScreenW-20, 30)];
        [_measureSpeedLabel setFont:[UIFont systemFontOfSize:18]];
        [_measureSpeedLabel setTextColor:[UIColor greenColor]];
        [_measureSpeedLabel setBackgroundColor:[UIColor lightGrayColor]];
        [_measureSpeedLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _measureSpeedLabel;
}

- (UILabel *)instantSpeedLabel {
    if (!_instantSpeedLabel) {
        _instantSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, DDYTopH+50, DDYScreenW-20, 30)];
        [_instantSpeedLabel setFont:[UIFont systemFontOfSize:18]];
        [_instantSpeedLabel setTextColor:[UIColor greenColor]];
        [_instantSpeedLabel setBackgroundColor:[UIColor lightGrayColor]];
        [_instantSpeedLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _instantSpeedLabel;
}

- (DDYNetworkSpeedTool *)netTool {
    if (!_netTool) {
        _netTool = [[DDYNetworkSpeedTool alloc] init];
    }
    return _netTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.measureButton];
    [self.view addSubview:self.measureSpeedLabel];
    [self.view addSubview:self.instantSpeedLabel];
    __weak __typeof (self)weakSelf = self;
    [self.netTool setMeasureBlock:^(NSError *error, BOOL finish, float speed) {
        __strong __typeof (weakSelf)strongSelf = weakSelf;
        if (error) {
            strongSelf.measureSpeedLabel.text = [NSString stringWithFormat:@"%@", error.description];
            strongSelf.measureButton.selected = NO;
        } else if (!finish){
            strongSelf.measureSpeedLabel.text = [NSString stringWithFormat:@"speed:%@/s",[strongSelf formatSpeed:speed]];
        } else {
            strongSelf.measureSpeedLabel.text = [NSString stringWithFormat:@"avarage:%@/s   bandwidth:%@",[strongSelf formatSpeed:speed], [strongSelf formatBandWidth:speed]];
            strongSelf.measureButton.selected = NO;
        }
    }];
    
    self.netTool.isMoniteInstantSpeed = YES;
    [self.netTool setInstantBlock:^(float upSpeed, float downSpeed) {
        __strong __typeof (weakSelf)strongSelf = weakSelf;
        strongSelf.instantSpeedLabel.text = [NSString stringWithFormat:@"up:%@  down:%@", [strongSelf formatSpeed:upSpeed], [strongSelf formatSpeed:downSpeed]];
    }];
    
    UIButton *pushNillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushNillButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushNillButton setFrame:CGRectMake(10.0 ,10.0 ,120.0 ,20.0)];
    pushNillButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00]; //背景颜
    [pushNillButton setTitle:@"返回" forState:(UIControlStateNormal)];
    [pushNillButton addTarget:self action:@selector(loadAddChildViewController) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pushNillButton];
}
- (void)loadAddChildViewController{
    if (self.instantBlock) {
        self.instantBlock(YES);
    }
}
- (UIButton *)btn:(CGFloat)x {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"title" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setFrame:CGRectMake(x, DDYTopH+10, 60, 60)];
    [button addTarget:self action:@selector(handleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)handleBtn {
    if ((_measureButton.selected = !_measureButton.selected)) {
        [self.netTool ddy_StartMeasureSpeed];
    } else {
        [self.netTool ddy_StopMeasureSpeed];
    }
}

- (NSString *)formatSpeed:(unsigned long long)size
{
    NSString *formattedStr = nil;
    if (size == 0) {
        formattedStr = @"0 KB";
    } else if (size > 0 && size < 1024) {
        formattedStr = [NSString stringWithFormat:@"%qubytes", size];
    } else if (size >= 1024 && size < pow(1024, 2)) {
        formattedStr = [NSString stringWithFormat:@"%.2fKB", (size / 1024.)];
    } else if (size >= pow(1024, 2) && size < pow(1024, 3)) {
        formattedStr = [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))];
    } else if (size >= pow(1024, 3)) {
        formattedStr = [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))];
    }
    return formattedStr;
}

- (NSString *)formatBandWidth:(unsigned long long)size
{
    size *=8;
    
    NSString *formattedStr = nil;
    if (size == 0) {
        formattedStr = @"0";
    } else if (size > 0 && size < 1024) {
        formattedStr = [NSString stringWithFormat:@"%qu", size];
    } else if (size >= 1024 && size < pow(1024, 2)) {
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        formattedStr = [NSString stringWithFormat:@"%dK", intsize];
    } else if (size >= pow(1024, 2) && size < pow(1024, 3)) {
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
        
    } else if (size >= pow(1024, 3)) {
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    return formattedStr;
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
