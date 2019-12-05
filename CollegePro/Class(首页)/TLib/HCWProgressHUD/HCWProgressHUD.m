//
//  HCWProgressHUD.m
//  Example
//
//  Created by BOOU on 2017/3/2.
//  Copyright © 2017年 HCW. All rights reserved.
//

#import "HCWProgressHUD.h"
#import "Masonry.h"

static const CGFloat kHCWProgressHUDPadding = 20.f;
static const CGFloat kHCWProgressHUDLabelFontSize = 15.f;

@interface HCWProgressHUD ()
@property (nonatomic, strong) UIView *cContentView;
@property (nonatomic, strong) UIImageView *cImageView;
@property (nonatomic, strong) UIActivityIndicatorView *cActivityIndicatorView;
@property (nonatomic, strong) UILabel *cLabel;
@property (nonatomic, strong) UIButton *cButton;

@property (nonatomic) BOOL originalScrollEnabled;
@end

@implementation HCWProgressHUD

#pragma mark - Class Methods

+ (HCW_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    return [self showHUDAddedTo:view
                       animated:animated
                tapContentBlock:NULL
               clickButtonBlock:NULL];
}

+ (HCW_INSTANCETYPE)showHUDAddedTo:(UIView *)view
                          animated:(BOOL)animated
                   tapContentBlock:(HCWProgressHUDTapContentBlock)tapContentBlock
                  clickButtonBlock:(HCWProgressHUDClickButtonBlock)clickButtonBlock
{
    HCWProgressHUD *hud = [[self alloc] initWithView:view];
    hud.tapContentBlock = tapContentBlock;
    hud.clickButtonBlock = clickButtonBlock;
    [view addSubview:hud];
    [hud show:animated];
    return hud;
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    HCWProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).scrollEnabled = hud.originalScrollEnabled;
        }
        [hud hide:animated];
        return YES;
    }
    return NO;
}

+ (HCW_INSTANCETYPE)HUDForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (HCWProgressHUD *)subview;
        }
    }
    return nil;
}

#pragma mark - Object Methods

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    if ([view isKindOfClass:[UIScrollView class]]) {
        self.originalScrollEnabled = ((UIScrollView *)view).scrollEnabled;
        ((UIScrollView *)view).scrollEnabled = NO;
    }
    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (void)show:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"HCWProgressHUD needs to be accessed on the main thread.");
    [self showUsingAnimation:animated];
}

- (void)hide:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"HCWProgressHUD needs to be accessed on the main thread.");
    [self hideUsingAnimation:animated];
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultConfig];
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor whiteColor];
        [self registerForKVO];
        [self setupSubviews];
        self.mode = HCWProgressHUDModeLoading;
    }
    return self;
}

- (void)dealloc {
    [self unregisterFromKVO];
}

#pragma mark - Private Methods

- (void)showUsingAnimation:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        self.alpha = 1.0f;
        self.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
    else {
        self.alpha = 1.0f;
    }
}

- (void)hideUsingAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.30 animations:^{
            self.alpha = 0.02f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        self.alpha = 0.0f;
        [self removeFromSuperview];
    }
}

- (void)setupSubviews
{
    // content view
    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor clearColor];
    [contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContenView:)]];
    [self addSubview:contentView];
    self.cContentView = contentView;
    
    // activity indicator view
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    activityIndicatorView.color = self.indicatorCorlor;
    [self.cContentView addSubview:activityIndicatorView];
    self.cActivityIndicatorView = activityIndicatorView;
    
    // image view
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cContentView addSubview:imageView];
    self.cImageView = imageView;
    
    // label
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.adjustsFontSizeToFitWidth = NO;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.opaque = NO;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.textCorlor;
    label.font = [UIFont systemFontOfSize:kHCWProgressHUDLabelFontSize];
    label.preferredMaxLayoutWidth = self.bounds.size.width;
    [label sizeToFit];
    [self.cContentView addSubview:label];
    self.cLabel = label;
    
    // button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:self.buttonCorlor forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:kHCWProgressHUDLabelFontSize];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 4;
    button.layer.borderColor = self.buttonCorlor.CGColor;
    button.layer.borderWidth = .5f;
    [self.cContentView addSubview:button];
    self.cButton = button;
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    typeof(self) __weak weakSelf = self;
    
    [self.cContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    [self.cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.cContentView);
        make.centerY.equalTo(weakSelf.cContentView.mas_centerY);
    }];
    
    [self.cActivityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.cLabel.mas_centerX);
        make.bottom.equalTo(weakSelf.cLabel.mas_top).offset(-kHCWProgressHUDPadding);
    }];
    
    [self.cImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.cLabel.mas_centerX);
        make.bottom.equalTo(weakSelf.cLabel.mas_top).offset(-kHCWProgressHUDPadding);
    }];
    
    [self.cButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.cLabel.mas_centerX);
        make.top.equalTo(weakSelf.cLabel.mas_bottom).offset(kHCWProgressHUDPadding);
        make.width.mas_equalTo(70);
    }];
}

- (void)updateMode
{
    if (self.mode == HCWProgressHUDModeLoading) {
        self.cActivityIndicatorView.hidden = NO;
        self.cButton.hidden = YES;
        self.cImageView.hidden = YES;
        [self.cActivityIndicatorView startAnimating];
        self.cLabel.text = self.loadingText;
        
    } else if (self.mode == HCWProgressHUDModeNoInternet) {
        self.cActivityIndicatorView.hidden = YES;
        self.cButton.hidden = !self.clickButtonBlock;
        self.cImageView.hidden = NO;
        [self.cActivityIndicatorView stopAnimating];
        self.cLabel.text = self.noInternetText;
        self.cImageView.image = self.noInternetImage;
        [self.cButton setTitle:self.noInternetButtonText forState:0];
        
    } else if (self.mode == HCWProgressHUDModeNoData) {
        self.cActivityIndicatorView.hidden = YES;
        self.cButton.hidden = !self.clickButtonBlock;
        self.cImageView.hidden = NO;
        [self.cActivityIndicatorView stopAnimating];
        self.cLabel.text = self.noDataText;
        self.cImageView.image = self.noDataImage;
        [self.cButton setTitle:self.noDataButtonText forState:0];
        
    } else if (self.mode == HCWProgressHUDModeCustom) {
        self.cActivityIndicatorView.hidden = YES;
        self.cButton.hidden = !self.clickButtonBlock;
        self.cImageView.hidden = NO;
        [self.cActivityIndicatorView stopAnimating];
        self.cLabel.text = self.customText;
        self.cImageView.image = self.customImage;
        [self.cButton setTitle:self.customButtonText forState:0];
        
    }
}

#pragma mark - Response Event

- (void)tapContenView:(UITapGestureRecognizer *)sender
{
    if (self.tapContentBlock) {
        self.tapContentBlock(_mode);
    }
}

- (void)clickButton:(UIButton *)sender
{
    if (self.clickButtonBlock) {
        self.clickButtonBlock(_mode);
    }
}

#pragma mark - KVO

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode", @"textCorlor", @"buttonCorlor", @"indicatorCorlor", @"loadingText", @"noInternetImage", @"noInternetText", @"noInternetButtonText", @"noDataImage", @"noDataText", @"noDataButtonText", @"customImage", @"customText", @"customButtonText", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    
    if ([keyPath isEqualToString:@"textCorlor"]) {
        self.cLabel.textColor = self.textCorlor;
    } else if ([keyPath isEqualToString:@"buttonCorlor"]) {
        [self.cButton setTitleColor:self.buttonCorlor forState:0];
        self.cButton.layer.borderColor = self.buttonCorlor.CGColor;
    } else if ([keyPath isEqualToString:@"indicatorCorlor"]) {
        self.cActivityIndicatorView.color = self.indicatorCorlor;
    } else {
        [self updateMode];
    }
     
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)defaultConfig
{
    self.textCorlor = [UIColor grayColor];
    self.buttonCorlor = [UIColor blueColor];
    
    // loading
    self.indicatorCorlor = [UIColor grayColor];
    self.loadingText = @"加载中...";
    
    // noInternet
    self.noInternetImage = [UIImage imageNamed:@"HCWProgressHUD.bundle/placeholder_slack"];
    self.noInternetText = @"当前网络不可用，请检查您的网络！";
    self.noInternetButtonText = @"检查网络";
    
    // noData
    self.noDataImage = [UIImage imageNamed:@"HCWProgressHUD.bundle/placeholder_instagram"];
    self.noDataText = @"没有找到任何数据";
    self.noDataButtonText = @"重新获取";
    
    // custom
    self.customImage = [UIImage imageNamed:@"HCWProgressHUD.bundle/placeholder_vesper"];
    self.customText = @"";
    self.customButtonText = @"";
}

@end
