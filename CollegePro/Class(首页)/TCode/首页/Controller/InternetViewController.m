//
//  InternetViewController.m
//  JHLivePlayLibrary
//
//  Created by xianjunwang on 2017/12/4.
//  Copyright © 2017年 pk. All rights reserved.
//

#import "InternetViewController.h"
#import "SignalControl.h"
#import "SpeedController.h"


@interface InternetViewController (){
    
    //取推流速度次数
    NSUInteger count;
    //是否已显示建议view
    __block BOOL isShowSuggestView;
}
//表盘view
@property (nonatomic,strong) UIView * dialView;
@property (nonatomic,strong) UIImageView * diaImageView;
//指针imageView
@property (nonatomic,strong) UIImageView * pointImageView;

//参数view
@property (nonatomic,strong) UIView * parameterView;
//建议view
@property (nonatomic,strong) UIView * suggestView;

@property (nonatomic,strong) CALayer * pointLayer;
//信号强度
@property (nonatomic,assign) float signalStrength;
//信号强度label
@property (nonatomic,strong) UILabel * signalStrengthLabel;
//上行速度label
@property (nonatomic,strong) UILabel * upstreamSpeedLabel;
//上行速度
@property (nonatomic,assign) float upstreamSpeed;
////下行速度label
//@property (nonatomic,strong) UILabel * downstreamSpeedLabel;
//推流速度label
@property (nonatomic,strong) UILabel * pushLabel;
//上传开始时间
@property (nonatomic,strong) NSDate * uploadStartTime;
//网络情况label
@property (nonatomic,strong) UILabel * internetLabel;
//优化建议标题label
@property (nonatomic,strong) UILabel * suggestTitleLabel;
//优化建议label
@property (nonatomic,strong) UILabel * suggestLabel;
//存储推流速度值的数组
@property (nonatomic,strong) NSMutableArray * dataArray;
//无网络view
@property (nonatomic,strong) UIView * noInternetView;
//重新检测按钮
@property (nonatomic,strong) UIButton * tryAgainBtn;

//有网显示的测速view
@property (nonatomic,strong) UIView * speedView;
 //推流速度
@property (nonatomic,assign) float pushSpeed;
//平均推流速度
@property (nonatomic,assign) float averagePushSpeed;
@end

@implementation InternetViewController

#pragma mark  ----  生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"网络检测";
    //获取信号强度
    [SpeedController getSignalStrength:^(float signalStrength) {
        
        self.signalStrength = signalStrength;
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ( self.signalStrength > 0) {
                
                [self.view addSubview:self.speedView];
                [self checkSignalStrengthAndUpstreamSpeed];
                
            }
            else{
                
                [self.view addSubview:self.noInternetView];
            }
        });
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[SpeedController sharedManager] stop];
}

#pragma mark  ----  自定义函数

//检测数据
-(void)checkSignalStrengthAndUpstreamSpeed{
    
    count = 5;
    self.signalStrength = 0;
    self.upstreamSpeed = 0;
    self.pushSpeed = 0.0;
    self.tryAgainBtn.userInteractionEnabled = NO;


    //获取信号强度
    [SpeedController getSignalStrength:^(float signalStrength) {

        self.signalStrength = signalStrength;
    }];
    
    //获取上行下行速度
    [[SpeedController sharedManager] getDownstreamSpeedAndUpstreamSpeed:^(float downstreamSpeed, float upstreamSpeed) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (downstreamSpeed == 1.0) {
                
                self.tryAgainBtn.userInteractionEnabled = YES;
                self.upstreamSpeed = upstreamSpeed;
                
                //上传带宽
                float bandwidth = upstreamSpeed * 8;
                
                NSString * bandwidthStr;
                if (bandwidth > 2.0) {
                    
                    bandwidthStr = @"> 2 Mbps";
                }
                else{
                    
                    bandwidthStr = [[NSString alloc] initWithFormat:@"%.2f Mbps",bandwidth];
                }
                
                self.upstreamSpeedLabel.text = bandwidthStr;
            }
            else{
             
                self.upstreamSpeed = upstreamSpeed;
                //上传带宽
                float bandwidth = upstreamSpeed * 8;
                
                NSString * bandwidthStr;
                if (bandwidth > 2.0) {
                    
                    bandwidthStr = @"> 2 Mbps";
                }
                else{
                    
                    bandwidthStr = [[NSString alloc] initWithFormat:@"%.2f Mbps",bandwidth];
                }
                
                self.upstreamSpeedLabel.text = bandwidthStr;
            }
        });
    }];
}

//旋转指针
- (void)updateWeightx:(CGFloat)weight {
    
    
    CGFloat angle = M_PI * weight;
    
    [UIView animateWithDuration:5 animations:^{
        self.pointImageView.transform = CGAffineTransformMakeRotation(angle);
    }];
    
}

//显示测速情况
-(void)showSpeedSuggest{
    
    if (self.upstreamSpeed >= 0.01) {
        
        self.suggestView.hidden = NO;
        self.tryAgainBtn.hidden = NO;
    }
    
    
    if (self.upstreamSpeed < 0.01) {
        
        [self.speedView removeFromSuperview];
        [self.view addSubview:self.noInternetView];
    }else if (self.averagePushSpeed < 0.01) {
        
        self.internetLabel.text = @"摄像机没有推流。";
        self.suggestTitleLabel.hidden = NO;
        self.suggestLabel.hidden = NO;
        
        NSString * forthStr = @"建议检查摄像机网络设置。";
        float height = 200;
        self.suggestLabel.frame = CGRectMake(CGRectGetMinX(self.suggestLabel.frame), CGRectGetMinY(self.suggestLabel.frame), CGRectGetWidth(self.suggestLabel.frame), height);
        self.suggestLabel.text = forthStr;
    }
    else if (self.signalStrength != 0 && self.upstreamSpeed != 0) {
     
        if (self.signalStrength >= 0.5 && self.upstreamSpeed >= 0.25) {
            
            if (self.pushSpeed > 0) {
                
                //信号好
                self.internetLabel.text = @"网络环境好";
                self.suggestTitleLabel.hidden = YES;
                self.suggestLabel.hidden = YES;
            }
            else{
                
                self.internetLabel.text = @"推流速度较差";
                self.suggestTitleLabel.hidden = NO;
                self.suggestLabel.hidden = NO;
                
                NSString * forthStr = @"建议检查摄像机网络设置或者设备硬件情况";
                float height = 20;
                self.suggestLabel.frame = CGRectMake(CGRectGetMinX(self.suggestLabel.frame), CGRectGetMinY(self.suggestLabel.frame), CGRectGetWidth(self.suggestLabel.frame), height);
                self.suggestLabel.text = forthStr;
            }
            
        }
        else if (self.signalStrength >= 0.5 && self.upstreamSpeed < 0.25){
            
            self.internetLabel.text = @"网络环境较差";
            self.suggestTitleLabel.hidden = NO;
            self.suggestLabel.hidden = NO;
            
            NSString * forthStr = @"建议增强网络带宽，上行带宽至少达到0.5Mbps。";
            float height = 20;
            self.suggestLabel.frame = CGRectMake(CGRectGetMinX(self.suggestLabel.frame), CGRectGetMinY(self.suggestLabel.frame), CGRectGetWidth(self.suggestLabel.frame), height);
            self.suggestLabel.text = forthStr;
            
        }
        else if (self.signalStrength < 0.5 && self.upstreamSpeed >= 0.25){
            
            self.internetLabel.text = @"网络环境较差";
            self.suggestTitleLabel.hidden = NO;
            self.suggestLabel.hidden = NO;
            
            NSString * forthStr = @"建议增强信号强度（信号强度至少为70%），可通过信号扩大器增强信号强度。";
            float height = 20;
            self.suggestLabel.frame = CGRectMake(CGRectGetMinX(self.suggestLabel.frame), CGRectGetMinY(self.suggestLabel.frame), CGRectGetWidth(self.suggestLabel.frame), height);
            self.suggestLabel.text = forthStr;
            
        }
        else if (self.signalStrength < 0.5 && self.upstreamSpeed < 0.25){
            
            self.internetLabel.text = @"网络环境较差";
            self.suggestTitleLabel.hidden = NO;
            self.suggestLabel.hidden = NO;
            
            NSString * forthStr = @"建议增强信号强度（信号强度至少为70%），可通过信号扩大器增强信号强度。建议增强网络带宽，上行带宽至少达到0.5Mbps。";
            float height = 20;
            self.suggestLabel.frame = CGRectMake(CGRectGetMinX(self.suggestLabel.frame), CGRectGetMinY(self.suggestLabel.frame), CGRectGetWidth(self.suggestLabel.frame), height);
            self.suggestLabel.text = forthStr;
            
        }
    }
}



//重新检测响应
-(void)chectBtnClicked{
    
    //获取信号强度
    [SpeedController getSignalStrength:^(float signalStrength) {
        
        self.signalStrength = signalStrength;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( self.signalStrength > 0) {
                
                [self.noInternetView removeFromSuperview];
                [self.speedView removeFromSuperview];
                self.dialView = nil;
                self. parameterView = nil;
                self.suggestView = nil;
                self.speedView = nil;
                isShowSuggestView = NO;
                [self.view addSubview:self.speedView];
                [self checkSignalStrengthAndUpstreamSpeed];
            }
        });
    }];
}

//测速成功的重新检测响应
-(void)tryBtnClicked:(UIButton *)btn{
    
    self.tryAgainBtn.hidden = YES;
    [[SpeedController sharedManager] stop];
    
    
    //获取信号强度
    [SpeedController getSignalStrength:^(float signalStrength) {
        
        self.signalStrength = signalStrength;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( self.signalStrength > 0) {
                
                self.signalStrength = 0;
                self.upstreamSpeed = 0;
                self.pushSpeed = 0;
                count = 0;
                isShowSuggestView = NO;
                
                [self.noInternetView removeFromSuperview];
                [self.speedView removeFromSuperview];
                self.dialView = nil;
                self. parameterView = nil;
                self.suggestView = nil;
                self.speedView = nil;
                [self.view addSubview:self.speedView];
                [self checkSignalStrengthAndUpstreamSpeed];
                
            }
            else{
                
                [self.speedView removeFromSuperview];
                [self.view addSubview:self.noInternetView];
            }
        });
    }];
}


#pragma mark  ----  SET
-(void)setSignalStrength:(float)signalStrength{
    
    _signalStrength = signalStrength;
    //旋转最大值
    float maxSignalStrength = 172.0 / 180.0;
    if (self.signalStrength >= maxSignalStrength) {
        
        [self updateWeightx:maxSignalStrength];
    }
    else{
        
        [self updateWeightx:self.signalStrength];
    }
    
    NSUInteger signal = self.signalStrength * 100;
    NSString * signalStrengthStr = [[NSString alloc] initWithFormat:@"%ld%@",signal,@"%"];
    self.signalStrengthLabel.text = signalStrengthStr;
}

//推流速度 MB/S
-(void)setPushSpeed:(float)pushSpeed{
    
    _pushSpeed = pushSpeed;
    
    NSLog(@"推流速度：%.2f",pushSpeed);
    if (pushSpeed >= 0.01) {
        
        [self.dataArray addObject:[NSNumber numberWithFloat:pushSpeed]];
    }
    
    float speed = 0.0;
    for (NSNumber * speedNumber in self.dataArray) {
        
        speed += speedNumber.floatValue;
    }
    
    if (speed > 0) {
        
        self.averagePushSpeed = speed / self.dataArray.count;
        self.pushLabel.text = [[NSString alloc] initWithFormat:@"%.2f KB/S",self.averagePushSpeed];
    }
    
    
    if (count == 0 && !isShowSuggestView) {
        
        [self showSpeedSuggest];
        isShowSuggestView = YES;
        [self.dataArray removeAllObjects];
    }
}

#pragma mark  ----  懒加载

-(UIView *)speedView{
    
    if (!_speedView) {
        
        _speedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _speedView.backgroundColor = [UIColor blueColor];
        
        [_speedView addSubview:self.tryAgainBtn];
        [_speedView addSubview:self.dialView];
        [_speedView addSubview:self.parameterView];
        [_speedView addSubview:self.suggestView];
    }
    return _speedView;
}

-(UIButton *)tryAgainBtn{
    
    if (!_tryAgainBtn) {
        
        _tryAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tryAgainBtn.tag = 10123;
        _tryAgainBtn.frame = CGRectMake((kScreenW - 80) / 2,22, 80, 24);
        _tryAgainBtn.backgroundColor = [UIColor blueColor];
        _tryAgainBtn.hidden = YES;
        _tryAgainBtn.userInteractionEnabled = NO;
        [_tryAgainBtn setTitle:@"重新检测" forState:UIControlStateNormal];
        [_tryAgainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tryAgainBtn addTarget:self action:@selector(tryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _tryAgainBtn.layer.masksToBounds = YES;
        _tryAgainBtn.layer.cornerRadius = 2;
    }
    return _tryAgainBtn;
}

-(UIView *)dialView{

    if (!_dialView) {
        
        _dialView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, kScreenW, 136)];
     
        UIImageView * firstImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JHLivePlayBundle.bundle/table.tiff"]];
        firstImageView.frame = CGRectMake((CGRectGetWidth(_dialView.frame) - 240) / 2, 0, 240, 136);
        [_dialView addSubview:firstImageView];
        self.diaImageView = firstImageView;
        
        UIImageView * secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JHLivePlayBundle.bundle/pointer.tiff"]];
        secondImageView.frame = CGRectMake(firstImageView.center.x - 72, CGRectGetMaxY(firstImageView.frame) - 24, 81, 18);
        [_dialView addSubview:secondImageView];
        self.pointImageView = secondImageView;
        /*
         设置锚点（以视图上的哪一点为旋转中心，（0，0）是左下角，（1，1）是右上角，（0.5，0.5）是中心）
         (0.5,roate)就是指针底部圆的圆心位置，我们旋转就是按照这个位置在旋转
         */
        CGRect oldFrame = secondImageView.frame;
        secondImageView.layer.anchorPoint = CGPointMake(0.9, 0.5);
        secondImageView.frame = oldFrame;
    }
    return _dialView;
}

-(UIView *)parameterView{
    
    if (!_parameterView) {
        
        _parameterView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dialView.frame) + 20, kScreenW, 140)];
        
        NSString * forthStr = @"网络环境检测";
        float forthWidth = 200;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 20, forthWidth, 22.0)];
        titleLabel.font = kFont(18);
        titleLabel.textColor = [UIColor blueColor];
        titleLabel.text = forthStr;
        [_parameterView addSubview:titleLabel];
        
        float width = [SignalControl viewWidthWithStr:@"信号强度信号"];
        
        //间隔宽度
        float interval = (kScreenW - width * 3 - CGRectGetMinX(titleLabel.frame) * 2) / 2;
        
        SignalControl * signalControl = [[SignalControl alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame) + 20, width, 42) andTitle:@"信号强度" andData:@"0"];
        [_parameterView addSubview:signalControl];
        self.signalStrengthLabel = signalControl.belowLabel;
        
        SignalControl * upstreamSpeedControl = [[SignalControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(signalControl.frame) + interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 42) andTitle:@"上行带宽" andData:@"0 Mbps"];
        [_parameterView addSubview:upstreamSpeedControl];
        self.upstreamSpeedLabel = upstreamSpeedControl.belowLabel;
        
//        SignalControl * downstreamSpeedControl = [[SignalControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(upstreamSpeedControl.frame) + interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 42) andTitle:@"下行速度" andData:@"0 MB/S"];
//        [_parameterView addSubview:downstreamSpeedControl];
//        self.downstreamSpeedLabel = downstreamSpeedControl.belowLabel;
        
        SignalControl * pushSpeedControl = [[SignalControl alloc] initWithFrame:CGRectMake(CGRectGetMaxX(upstreamSpeedControl.frame) + interval, CGRectGetMaxY(titleLabel.frame) + 20, width, 42) andTitle:@"推流速度" andData:@"0.00 KB/S"];
        [_parameterView addSubview:pushSpeedControl];
        self.pushLabel = pushSpeedControl.belowLabel;
        
    }
    return _parameterView;
}

-(UIView *)suggestView{
    
    if (!_suggestView) {
        
        _suggestView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.parameterView.frame) + 20, kScreenW, 60)];
        _suggestView.hidden = YES;
        
        NSString * firstStr = @"总体情况";
        float firstWidth = 200;
        UILabel * firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, firstWidth, 14)];
        firstLabel.font = kFont(14);
        firstLabel.text = firstStr;
        [_suggestView addSubview:firstLabel];
        
        UILabel * secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLabel.frame) + 12, 0, kScreenW - 12 - CGRectGetMaxX(firstLabel.frame), 14)];
        secondLabel.font = kFont(14);
        secondLabel.text = @"";
        [_suggestView addSubview:secondLabel];
        self.internetLabel = secondLabel;
        
        
        NSString * thirdStr = @"优化建议";
        float thirdWidth = 100;
        UILabel * thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(firstLabel.frame) + 12, thirdWidth, 14)];
        thirdLabel.font = kFont(14);
        thirdLabel.text = thirdStr;
        thirdLabel.hidden = YES;
        [_suggestView addSubview:thirdLabel];
        self.suggestTitleLabel = thirdLabel;
        
      
        
        UILabel * forthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdLabel.frame) + 12, CGRectGetMinY(thirdLabel.frame), kScreenW - 12 - CGRectGetMaxX(thirdLabel.frame), 0)];
        forthLabel.font = kFont(14);
        forthLabel.text = @"";
        forthLabel.numberOfLines = 0;
        forthLabel.lineBreakMode = NSLineBreakByCharWrapping;
        forthLabel.hidden = YES;
        [_suggestView addSubview:forthLabel];
        self.suggestLabel = forthLabel;
    }
    return _suggestView;
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(UIView *)noInternetView{
    
    if (!_noInternetView) {
        
        _noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.noInternetView.frame), 22)];
        label.font = kFont(18);
        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"没有获取到摄像机的网络环境数据";
        [_noInternetView addSubview:label];
        
        UIButton * checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake((CGRectGetWidth(self.noInternetView.frame) - 98) / 2, CGRectGetMaxY(label.frame) + 84, 98, 34);
        checkBtn.backgroundColor = [UIColor blueColor];
        [checkBtn setTintColor:[UIColor whiteColor]];
        [checkBtn setTitle:@"重新检测" forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(chectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.layer.masksToBounds = YES;
        checkBtn.layer.cornerRadius = 4;
        [_noInternetView addSubview:checkBtn];
    }
    return _noInternetView;
}


@end
