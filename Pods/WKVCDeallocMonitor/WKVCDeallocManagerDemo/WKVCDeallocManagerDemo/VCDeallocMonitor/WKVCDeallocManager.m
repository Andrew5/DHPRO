//
//  WKVCDeallocManger.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCDeallocManager.h"
#import "WKVCDeallocListVC.h"
#import "WKVCLifeCircleRecordManager.h"
#import "UIView+WKSnapImage.h"
#import "WKBaseView.h"



#ifdef DEBUG

#define OPEN_Warnning 1

#endif

@interface WKDeallocModel ()

@property (nonatomic, strong) NSString * className;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) UIImage * img;
@property (nonatomic, assign) NSTimeInterval releaseTime;
@property (nonatomic, assign) BOOL isNeedRelease;


@end

@implementation WKDeallocModel

+ (instancetype)createWithObject:(id)object
{
    if (!object) {
        return nil;
    }
    WKDeallocModel * model = [WKDeallocModel new];
    model.className = [object className];
    model.address = [NSString stringWithFormat:@"%p",object];
    if ([object isKindOfClass:[UIView class]])
    {
        model.img = [((UIView *)object) wk_snapshotImageAfterScreenUpdates:NO];
    }
    else if ([object isKindOfClass:[UIViewController class]])
    {
        model.img = [((UIViewController *)object).view wk_snapshotImageAfterScreenUpdates:NO];
    }
    model.isNeedRelease = NO;
    return model;
}

- (BOOL)isEqual:(id)object
{
    NSString * className = @"";
    NSString * address = @"";
    if ([object isKindOfClass:[WKDeallocModel class]]) {
        WKDeallocModel * model = (WKDeallocModel *)object;
        className = model.className;
        address = model.address;
    }
    else if ([object isKindOfClass:[WKVCLifeCircleRecordModel class]])
    {
        WKVCLifeCircleRecordModel * model = (WKVCLifeCircleRecordModel *)object;
        className = model.className;
        address = model.address;
    }
    else
    {
        className = [object className];
        address = [NSString stringWithFormat:@"%p",object];
    }
    BOOL classNameIsEqual = [self.className isEqual:className];
    BOOL addressIsEqual = [self.address isEqual:address];
    return classNameIsEqual && addressIsEqual;
}

@end

@interface WKVCDeallocManager ()

@property (nonatomic, strong) NSMutableArray <WKDeallocModel *> * models;
@property (nonatomic, strong) NSMutableArray <WKDeallocModel *> * warnningModels;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) UILabel * warnningLabel;
@property (nonatomic, strong) UIView * warnningView;

@property (nonatomic, assign) CGRect * originFrame;

@end

@implementation WKVCDeallocManager

+ (instancetype)sharedVCDeallocManager
{
    static WKVCDeallocManager * cm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cm = [WKVCDeallocManager new];
        cm.count = 0;
#ifdef OPEN_Warnning
        cm.isWarnning = YES;
#else
        cm.isWarnning = NO;
#endif
    });
    return cm;
}

+ (void)addWithObject:(id)object
{
#ifdef OPEN_Warnning
    if (!object) {
        return;
    }
    WKVCDeallocManager * cm = [self sharedVCDeallocManager];
    BOOL isExist = NO;
    for (WKDeallocModel * tmp in cm.models) {
        if ([tmp isEqual:object]) {
            isExist  = YES;
            tmp.isNeedRelease = NO;
            if ([cm.warnningModels containsObject:tmp]) {
                [cm.warnningModels removeObject:tmp];
                cm.count = cm.warnningModels.count;
            }
            break;
        }
    }
    if (!isExist) {
        WKDeallocModel * model = [WKDeallocModel createWithObject:object];
        [cm.models addObject:model];
    }
#endif
}

+ (void)removeWithObject:(id)object
{
#ifdef OPEN_Warnning
    if (!object) {
        return;
    }
    WKVCDeallocManager * cm = [self sharedVCDeallocManager];
    WKDeallocModel * needRemoveModel = nil;
    for (WKDeallocModel * tmp in cm.models) {
        if ([tmp isEqual:object]) {
            needRemoveModel = tmp;
            break;
        }
    }
    if (needRemoveModel) {
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController * vc = (UIViewController *)object;
            for (UIViewController * tmp in vc.childViewControllers) {
                [self removeWithObject:tmp];
            }
        }
        [cm.models removeObject:needRemoveModel];
        if ([cm.warnningModels containsObject:needRemoveModel]) {
            [cm.warnningModels removeObject:needRemoveModel];
            cm.count = cm.warnningModels.count;
        }
    }
#endif
}

+ (void)releaseWithObject:(id)object
{
#ifdef OPEN_Warnning
    if (!object) {
        return;
    }
    WKVCDeallocManager * cm = [self sharedVCDeallocManager];
    WKDeallocModel * needRemoveModel  = nil;
    for (WKDeallocModel * tmp in cm.models) {
        if ([tmp isEqual:object]) {
            tmp.isNeedRelease = YES;
            needRemoveModel = tmp;
            break;
        }
    }
    
    if (needRemoveModel) {
        if ([object isKindOfClass:[UIViewController class]]) {
            UIViewController * vc = (UIViewController *)object;
            for (UIViewController * tmp in vc.childViewControllers) {
                [self releaseWithObject:tmp];
            }
        }
        needRemoveModel.releaseTime = [[NSDate date] timeIntervalSince1970];
        [cm.warnningModels addObject:needRemoveModel];
        cm.count = cm.warnningModels.count;
        [NSThread cancelPreviousPerformRequestsWithTarget:cm selector:@selector(checkDeallocState) object:nil];
        [cm performSelector:@selector(checkDeallocState) withObject:nil afterDelay:1.0];
    }

#endif
}

+ (NSArray *)findRecordModelWithDeallocModel:(WKDeallocModel *)model
{
    if (model.releaseTime <= 100) {
        return nil;
    }
    NSArray * source = [WKVCLifeCircleRecordManager sharedVCLifeCircleRecordManager].models;
    NSTimeInterval startTime = 0;
    for (WKVCLifeCircleRecordModel * lcModel in source) {
        if ([model isEqual:lcModel]) {
            if ([lcModel.methodName containsString:@"viewDidLoad"])
            {
                startTime = lcModel.time;
                break;
            }
        }
    }
    if (startTime > 0) {
        NSMutableArray * result = [NSMutableArray array];
        for (WKVCLifeCircleRecordModel * lcModel in source) {
            if (lcModel.time >= startTime && lcModel.time <= model.releaseTime) {
                [result addObject:lcModel];
            }
        }
        return  result;
    }
    return nil;
}


- (void)checkDeallocState
{
    if (self.warnningModels.count > 0 && self.isWarnning)
    {
        //存在东西未释放
        //show
        [self showWarnning];
    }
}



- (void)showWarnning
{
    self.warnningView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.warnningView.alpha = 1;
    }];
}

- (void)hideWarnning
{
    [UIView animateWithDuration:0.25 animations:^{
        self.warnningView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.warnningView.hidden = YES;
        }
    }];
}

- (void)enterListVC
{
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!vc) {
        for (UIWindow * window in [UIApplication sharedApplication].windows) {
            if (window.rootViewController) {
                vc = window.rootViewController;
                break;
            }
        }
    }
    if (vc) {
        vc = [self getVisableVCWithVC:vc];
        BOOL isExist = NO;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)vc;
            for (UIViewController * tmp in nav.viewControllers) {
                if ([tmp isKindOfClass:NSClassFromString(@"WKVCDeallocListVC")]) {
                    isExist = YES;
                    break;
                }
            }
        }
        else
        {
            isExist = [vc isKindOfClass:NSClassFromString(@"WKVCDeallocListVC")];
        }
        if (!isExist) {
            WKVCDeallocListVC * deallocListVC = [[WKVCDeallocListVC alloc] init];
            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:deallocListVC];
            [vc presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (UIViewController *)getVisableVCWithVC:(UIViewController *)viewcontroller
{
    UIViewController * vc = viewcontroller;
    while ([vc isKindOfClass:[UITabBarController class]]) {
        vc = ((UITabBarController *)vc).selectedViewController;
    }
    while ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).visibleViewController;
    }
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)warningLabelPan:(UIPanGestureRecognizer *)pan
{
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:
            self.warnningView.center = [pan locationInView:self.warnningView.superview];
            break;
        default:
            break;
    }
}

- (NSMutableArray<WKDeallocModel *> *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSMutableArray<WKDeallocModel *> *)warnningModels
{
    if (!_warnningModels) {
        _warnningModels = [NSMutableArray array];
    }
    return _warnningModels;
}

- (void)setCount:(NSUInteger)count
{
    _count = count;
    if (count == 0) {
        [self hideWarnning];
    }
}

- (void)setIsWarnning:(BOOL)isWarnning
{
    _isWarnning = isWarnning;
    if (!isWarnning) {
        [self hideWarnning];
    }
    else
    {
        if (self.count > 0) {
            [self showWarnning];
        }
    }
}

- (UIView *)warnningLabel
{
    if (!_warnningLabel) {
        _warnningLabel = [UILabel new];
        _warnningLabel.font = [UIFont systemFontOfSize:10];
        _warnningLabel.textColor = [UIColor whiteColor];

        _warnningLabel.frame = CGRectMake(0, 0, 40, 40);
        _warnningLabel.text = @"Leak";
        _warnningLabel.textAlignment = NSTextAlignmentCenter;

        [self hideWarnning];
    }
    return _warnningLabel;
}

- (UIView *)warnningView
{
    if (!_warnningView) {
        _warnningView = [UIView new];
        _warnningView.frame = CGRectMake(0, WK_NAVIGATION_STATUS_HEIGHT, 40, 40);
        _warnningView.layer.cornerRadius = 20;
        _warnningView.clipsToBounds = YES;
        _warnningView.userInteractionEnabled = YES;
        [_warnningView addSubview:self.warnningLabel];
        [_warnningView setBackgroundColor:[UIColor colorWithRed:252 / 255.0 green:100 / 255.0 blue:84 / 255.0 alpha:1]];
        UIView * keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:_warnningView];
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(warningLabelPan:)];
        [_warnningView addGestureRecognizer:pan];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterListVC)];
        [tap requireGestureRecognizerToFail:pan];
        [_warnningView addGestureRecognizer:tap];
    }
    return _warnningView;
}



@end
