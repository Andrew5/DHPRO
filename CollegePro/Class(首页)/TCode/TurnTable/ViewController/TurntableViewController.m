//
//  TurntableViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/9.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "TurntableViewController.h"
#import "HCWProgressHUD.h"
#import "AppDelegate.h"
@interface TurntableViewController ()<CAAnimationDelegate>
{
    UIImageView *_bgImageView;
    BOOL _isAnimation;
    float _circleAngle;
}
@property (nonatomic,assign) BOOL isFullPlay;
@property (nonatomic,strong) UIButton * offlineBtn;


@end

@implementation TurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self indeHD];
    [self.view addSubview:self.offlineBtn];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotate = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotate = YES;
}
-(void)fullScreen{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //此方案为转屏
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = YES;
    if (self.isFullPlay == NO) {
        self.isFullPlay = YES;
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;//这里可以改变旋转的方向
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    } else {
        self.isFullPlay = NO;
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//这里可以改变旋转的方向
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}
- (void)orientChange:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            self.isFullPlay = YES;

        }else{
            if (orientation == UIDeviceOrientationPortrait) {
                self.isFullPlay = NO;
                
            }
        }
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.allowRotate = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    });
    
}
- (void)willResignActive{
    
    [self fullScreen];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)indeHD{
    HCWProgressHUD *hud = [HCWProgressHUD showHUDAddedTo:self.view animated:YES tapContentBlock:^(HCWProgressHUDMode mode) {
        
    } clickButtonBlock:^(HCWProgressHUDMode mode) {
        
    }];
    
    hud.buttonCorlor = [UIColor blueColor];
    
    // 没有网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hud.mode = HCWProgressHUDModeNoInternet;
        
        // 没有数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.mode = HCWProgressHUDModeNoData;
            
            // 隐藏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HCWProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    });
}
#pragma mark 初始化View
-(void)initView{

    //转盘背景
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DH_DeviceWidth-50,DH_DeviceWidth-50)];
    _bgImageView.center = self.view.center;
//    _bgImageView.image = [UIImage imageNamed:@"bg2"];
    _bgImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bgImageView];
    
    //添加GO按钮图片
    UIImageView *btnimage = [[UIImageView alloc]initWithFrame:CGRectMake(DH_DeviceWidth/2-50, DH_DeviceHeight/2-70, 100, 118)];
//    btnimage.image = [UIImage imageNamed:@"btn"];
    btnimage.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:btnimage];
    
    _bgImageView.userInteractionEnabled = YES;
    btnimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    [btnimage addGestureRecognizer:tap];
    
    //添加文字
    NSArray *_prizeArray = @[@"谢谢参与",@"一等奖",@"谢谢参与",@"二等奖",@"谢谢参与",@"三等奖",@"谢谢参与",@"特等奖"];
    
    for (int i = 0; i < 8; i ++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,M_PI * CGRectGetHeight(_bgImageView.frame)/8,CGRectGetHeight(_bgImageView.frame)*3/5)];
        label.layer.anchorPoint = CGPointMake(0.5, 1.0);
        label.center = CGPointMake(CGRectGetHeight(_bgImageView.frame)/2, CGRectGetHeight(_bgImageView.frame)/2);
        label.text = [NSString stringWithFormat:@"%@", _prizeArray[i]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        CGFloat angle = M_PI*2/8 * i;
        label.transform = CGAffineTransformMakeRotation(angle);
        [_bgImageView addSubview:label];
        
    }
    
}
#pragma mark 点击Go按钮
-(void)btnClick{
    /*
     1、可以设定一个固定的圈数，然后再转1圈，就是360度，我们在最后一圈产生随机的度数
     2、箭头一直朝上不动，转动的是背景转盘，箭头对着一块的中心，再接下来转的时候也让其对着某一块的中心，如特等奖对应着45度，三等奖对应着135度，以此类推。。。
     */
    NSLog(@"点击Go");
    
    //判断是否正在转
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;
    
    //控制概率[0,80)
    NSInteger lotteryPro = arc4random()%80;
    //设置转圈的圈数
    NSInteger circleNum = 6;
    
    if (lotteryPro < 10) {
        _circleAngle = 0;
    }else if (lotteryPro < 20){
        _circleAngle = 45;
    }else if (lotteryPro < 30){
        _circleAngle = 90;
    }else if (lotteryPro < 40){
        _circleAngle = 135;
    }else if (lotteryPro < 50){
        _circleAngle = 180;
    }else if (lotteryPro < 60){
        _circleAngle = 225;
    }else if (lotteryPro < 70){
        _circleAngle = 270;
    }else if (lotteryPro < 80){
        _circleAngle = 315;
    }
    
    CGFloat perAngle = M_PI/180.0;
    
    NSLog(@"turnAngle = %ld",(long)_circleAngle);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    /*
     设置了转的圈数是6圈，然后随机生成一个0~80的数字，每一个10对应转盘八等份的其中一份，然后设置最后一圈转的角度，这些概率都是自由设置的，你可以把一等奖中奖的概率设高点，我们这里谢谢参数有50%的概率，所以转到谢谢参与的机会比较多！
     多少圈乘以360度再加上最后的度数
     */
    rotationAnimation.toValue = [NSNumber numberWithFloat:_circleAngle * perAngle + 360 * perAngle * circleNum];
    rotationAnimation.duration = 3.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.delegate = self;
    
    
    //由快变慢
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [_bgImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
#pragma mark 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _isAnimation = NO;

    NSLog(@"动画停止");
    NSString *title;
    if (_circleAngle == 0) {
        title = @"谢谢参与!";
    }else if (_circleAngle == 45){
        title = @"恭喜你，获得特等奖！";
    }else if (_circleAngle == 90){
        title = @"谢谢参与!";
    }else if (_circleAngle == 135){
        title = @"恭喜你，获得三等奖！";
    }else if (_circleAngle == 180){
        title = @"谢谢参与!";
    }else if (_circleAngle == 225){
        title = @"恭喜你，获得二等奖！";
    }else if (_circleAngle == 270){
        title = @"谢谢参与!";
    }else if (_circleAngle == 315){
        title = @"恭喜你，获得一等奖！";
    }
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
/**
 离线状态下播放按钮
 
 @return 播放按钮
 */
-(UIButton *)offlineBtn{
    
    if (!_offlineBtn) {
        
        _offlineBtn = [[UIButton alloc] initWithFrame:CGRectMake(30 , 80 , 30.2, 34.8)];
        [_offlineBtn setImage:[UIImage imageNamed:@"play_def"] forState:UIControlStateNormal];
        [_offlineBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        _offlineBtn.layer.borderColor = [UIColor blueColor].CGColor;
        _offlineBtn.layer.borderWidth = 1.0;
    }
    return _offlineBtn;
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
