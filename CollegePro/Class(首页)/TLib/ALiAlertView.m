//
//  ALiAlertView.m
//  ALiAlertView
//
//  Created by LeeWong on 2016/11/4.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#define lineColor [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
#define buttonTitleColor [UIColor colorWithRed:4./255.0 green:124./255.0 blue:255./255.0 alpha:1.0f]
#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

#import "ALiAlertView.h"
#import <CoreMotion/CoreMotion.h>

const static CGFloat kDefaultButtonHeight       = 44;
const static CGFloat kDefaultLineHeightOrWidth  = 1;
const static CGFloat kDefaultCornerRadius       = 13;
const static CGFloat kDefaultAlertWidth         = 270;
const static CGFloat kDefaultHeaderHeight       = 60;

@interface ALiAlertView ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) UIInterfaceOrientation lastOrientation;

//整体的View
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *msgView;
@property (nonatomic, strong) UILabel *tipLabel;
//数据
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableDictionary *actionDict;
@property (nonatomic, strong) NSString *tipMsg;
@property (nonatomic, assign) CGFloat msgHeight;

@end

@implementation ALiAlertView

#pragma mark - Public Method

- (void)show
{
    if (self.contentView == nil) {
        //使用默认的样式
        [self configHeaderView];
    } else {
        self.msgHeight = self.contentView.frame.size.height - kDefaultHeaderHeight;
        [self defaultSetting];
        [self buildUI];
        self.contentView.frame = CGRectMake((kDefaultAlertWidth - self.contentView.frame.size.width)/2.,0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [self.msgView addSubview:self.contentView];
    }
    [self configButtonView];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    [self doAlertShowAnimation];

}

- (void)dismiss{
    [self doAlertDismissAnimation];
    [self removeFromSuperview];
}


- (void)addButtonWithTitle:(NSString *)title whenClick:(void (^)(NSInteger))clickHandler
{
    [self.actionDict setValue:clickHandler forKey:title];
    [self.titles addObject:title];
}

- (void)buttonDidClick:(UIButton *)aButton
{
    void (^clickBlock)(NSInteger index) = [self.actionDict valueForKey:aButton.currentTitle];
    if (clickBlock) {
        [self dismiss];
        clickBlock(aButton.tag-1000);
    }
}

#pragma mark - Load View

- (void)buildUI
{
    CGSize screen = [self screenSize];
    CGSize container = [self containerSize];
    self.frame = CGRectMake((screen.width - container.width)/2., (screen.height - container.height)/2., container.width,container.height);
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, kDefaultHeaderHeight+self.msgHeight, kDefaultAlertWidth, 1)];
    hLine.backgroundColor = lineColor;
    [self.containerView addSubview:hLine];
}

- (void)configButtonView
{
    if (self.titles.count == 0) {
        //默认的
        [self defaultStyle];
    }
    
    CGFloat width = (kDefaultAlertWidth - (self.titles.count - 1) * kDefaultLineHeightOrWidth)/self.titles.count;
    for (NSInteger index = 0; index < self.titles.count; index++) {
        NSString *title = self.titles[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index + 1000;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:buttonTitleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:18.];
        [self.buttonView addSubview:button];
        button.frame = CGRectMake(width * index, 0, width, kDefaultButtonHeight);
        
        if ((index >= 1) && (index != [self.titles count])) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(index * (width+kDefaultLineHeightOrWidth), button.frame.origin.y, kDefaultLineHeightOrWidth, button.bounds.size.height)];
            lineView.backgroundColor = lineColor;
            [self.buttonView addSubview:lineView];
        }
    }
}

- (void)configHeaderView
{
    self.tipLabel.text = self.tipMsg;
}

#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)aTitle
{
    if (self = [self init]) {
        self.tipMsg = aTitle;
        [self defaultSetting];
        CGSize size = [self sizeString:aTitle withFont:[UIFont systemFontOfSize:18]];
        self.msgHeight = size.height;
        [self buildUI];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if([self.motionManager isAccelerometerAvailable] && self.roattionEnable){
        [self orientationChange];
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    if (self.motionManager) {
        [self.motionManager stopAccelerometerUpdates];
        self.motionManager = nil;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - Private Method

- (CGSize)screenSize
{
    if (self.lastOrientation == UIInterfaceOrientationPortrait || self.lastOrientation == UIInterfaceOrientationUnknown) {
        
        return CGSizeMake(SCREEN_W,SCREEN_H);
    } else {
     return CGSizeMake(SCREEN_H,SCREEN_W);
    }
    return CGSizeZero;
}

- (CGSize)containerSize
{
    return CGSizeMake(kDefaultAlertWidth, kDefaultButtonHeight + kDefaultHeaderHeight + self.msgHeight);
}

- (void)doAlertShowAnimation
{
    self.containerView.layer.opacity = 0.5f;
    self.containerView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.containerView.layer.opacity = 1.0f;
                         self.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}


- (void)doAlertDismissAnimation
{
    CATransform3D currentTransform = self.containerView.layer.transform;
    self.containerView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.containerView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}


- (CGSize)sizeString:(NSString *)aStr withFont:(UIFont *)font
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [aStr boundingRectWithSize:CGSizeMake(kDefaultAlertWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}

- (void)defaultStyle
{
    NSString *title = @"取消";
    self.titles = [NSMutableArray arrayWithArray:@[title]];
    void (^clickBlock)(NSInteger index) = ^(NSInteger index){
        [self removeFromSuperview];
    };
    [self.actionDict setValue:clickBlock forKey:title];
}

- (void)defaultSetting
{
    self.orientation = UIInterfaceOrientationPortrait;
    self.roattionEnable = YES;
    self.tapDismissEnable = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kDefaultCornerRadius;
    self.titles = [NSMutableArray array];
    self.actionDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘处理
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self screenSize];
    CGSize dialogSize = [self containerSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self screenSize];
    CGSize dialogSize = [self containerSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

#pragma mark - 点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.tapDismissEnable) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[ALiAlertView class]]) {
        [self dismiss];
    }
}

#pragma mark - 屏幕方向旋转
- (void)orientationChange
{
    WEAKSELF(weakSelf);
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        __block UIInterfaceOrientation orientation;
        if (acceleration.x >= 0.75) {
            orientation = UIInterfaceOrientationLandscapeLeft;
        }
        else if (acceleration.x <= -0.75) {
            orientation = UIInterfaceOrientationLandscapeRight;
            
        }
        else if (acceleration.y <= -0.75) {
            orientation = UIInterfaceOrientationPortrait;
            
        }
        else if (acceleration.y >= 0.75) {
            orientation = UIInterfaceOrientationPortraitUpsideDown;
            return ;
        }
        else {
            // Consider same as last time
            return;
        }
        
        if (orientation != weakSelf.lastOrientation) {
            [weakSelf configHUDOrientation:orientation];
            weakSelf.lastOrientation = orientation;
            NSLog(@"%tu=-------%tu",orientation,weakSelf.lastOrientation);
        }
        
    }];
}

- (void)configHUDOrientation:(UIInterfaceOrientation )orientation
{
    CGFloat angle = [self calculateTransformAngle:orientation];
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformRotate(self.transform, angle);
    }];
}


- (CGFloat)calculateTransformAngle:(UIInterfaceOrientation )orientation
{
    CGFloat angle;
    if (self.lastOrientation == UIInterfaceOrientationPortrait) {
        switch (orientation) {
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = -M_PI_2;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeRight) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = -M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                angle = M_PI;
                break;
            default:
                break;
        }
    } else if (self.lastOrientation == UIInterfaceOrientationLandscapeLeft) {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                angle = M_PI_2;
                break;
            case UIInterfaceOrientationLandscapeRight:
                angle = M_PI;
                break;
            default:
                break;
        }
    }
    return angle;
}

#pragma mark - Lazy Load
- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 1./15.;
        
    }
    return _motionManager;
}

- (UIView *)containerView
{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.alpha = 0.9;
        _containerView.layer.cornerRadius = kDefaultCornerRadius;
        _containerView.clipsToBounds = YES;
        _containerView.frame = self.bounds;
        [self addSubview:self.containerView];

    }
    return _containerView;
}

- (UIView *)buttonView
{
    if (_buttonView == nil) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, kDefaultHeaderHeight+self.msgHeight, kDefaultAlertWidth, kDefaultButtonHeight)];
        [self.containerView addSubview:_buttonView];
    }
    return _buttonView;
}

- (UIView *)msgView
{
    if (_msgView == nil) {
        _msgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultAlertWidth, kDefaultHeaderHeight+self.msgHeight)];
        [self.containerView addSubview:_msgView];
    }
    return _msgView;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDefaultAlertWidth-20, kDefaultHeaderHeight-20+self.msgHeight)];
        _tipLabel.font = [UIFont boldSystemFontOfSize:18];
        _tipLabel.numberOfLines = 0.;
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.msgView addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
