//
//  DHBAlertView.m
//  CollegePro
//
//  Created by jabraknight on 2020/4/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHBAlertView.h"
#import "UIColor+expanded.h"
#define animateTime  0.25f
#define titleFont 18
#define detailFont 16
#define plainHeight 95
#define kSelfFontName @"HelveticaNeue"
@implementation DHBAlertView
{
    NSString *_storeFlagStr;
}
#pragma mark - 单例
+ (DHBAlertView *)sharedAlertView
{
    static DHBAlertView * _alertView = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _alertView = [[self alloc] init];
    });
    return _alertView;
}

#pragma mark - 创建UI
- (void)showAlertWithMode:(AlertViewType)mode storeFlag:(NSString *)storeFlag param:(NSMutableDictionary*)param action:(ClickBlock)okBlock
{
    [self showAlertWithMode:mode param:param action:okBlock];
    
    if (storeFlag != nil) {
        // 不再显示按钮
        [self.operateView addSubview:self.neverShowBtn];
        [self.neverShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.operateView.mas_right).offset(-10);
            make.bottom.equalTo(self.operateView.mas_bottom).offset(-6);
            make.height.mas_equalTo(@30);
        }];
        
        _storeFlagStr = storeFlag;
    }
}

- (void)showAlertWithMode:(AlertViewType)mode param:(NSMutableDictionary*)param action:(ClickBlock)okBlock
{
    int padding = 10;
    float titleHeight = [self heightForString:param[@"title"] fontSize:titleFont andWidth:DH_DeviceWidth-40];
    float detailHeight = [self heightForString:param[@"detail"] fontSize:detailFont andWidth:DH_DeviceWidth-40];
    // 背景视图
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.alertBgView];
    [UIView animateWithDuration:animateTime animations:^{
        self.alertBgView.alpha = 1;
    }];
    // 操作区背景
    [self.alertBgView addSubview:self.operateView];
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertBgView.mas_left).offset(padding);
        make.right.equalTo(self.alertBgView.mas_right).offset(-padding);
        make.centerY.equalTo(self.alertBgView.mas_centerY);
        make.height.mas_equalTo(titleHeight + detailHeight + plainHeight);
    }];
    // 标题
    [self.operateView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.operateView.mas_top).offset(padding);
        make.centerX.equalTo(self.operateView.mas_centerX);
        make.left.equalTo(self.operateView.mas_left).offset(padding);
        make.right.equalTo(self.operateView.mas_right).offset(-padding);
    }];
    if(param[@"title"]) {
        self.titleLabel.text = param[@"title"];
    }
    // 副标题
    if(param[@"detail"]) {
        [self.operateView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(padding*2);
            make.centerX.equalTo(self.operateView.mas_centerX);
            make.left.equalTo(self.operateView.mas_left).offset(padding);
            make.right.equalTo(self.operateView.mas_right).offset(-padding);
        }];
        
        self.detailLabel.text = param[@"detail"];
    }
    
    [self.operateView addSubview:self.okButton];
    if (mode == OkCancelType) {
        // 确定按钮
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.operateView.mas_right).offset(-padding);
            make.left.equalTo(self.operateView.mas_centerX).offset(padding);
            make.bottom.equalTo(self.operateView.mas_bottom).offset(-padding);
            make.height.mas_equalTo(@35);
        }];
        // 取消按钮
        [self.operateView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operateView.mas_left).offset(padding);
            make.right.equalTo(self.operateView.mas_centerX).offset(-padding);
            make.bottom.equalTo(self.operateView.mas_bottom).offset(-padding);
            make.height.mas_equalTo(@35);
        }];
        if(param[@"cancelButtonName"]) {
            [self.cancelButton setTitle:param[@"cancelButtonName"] forState:UIControlStateNormal];
        }
        else {
            [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    else if (mode == OnlyOkType) {
        // 确定按钮
        [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.operateView.mas_centerX);
            make.bottom.equalTo(self.operateView.mas_bottom).offset(-padding);
            make.width.mas_equalTo(@100);
            make.height.mas_equalTo(@35);
        }];
    }
    if(param[@"okButtonName"]) {
        [self.okButton setTitle:param[@"okButtonName"] forState:UIControlStateNormal];
    }
    else {
        [self.okButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    self.okBlock = okBlock;
}

#pragma mark - 根据字符串的的长度来计算高度
- (float)heightForString:(NSString *)string fontSize:(float)fontSize andWidth:(float)width
{
    float height;
    if (string) {
        height = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kSelfFontName size:fontSize],NSFontAttributeName, nil] context:nil].size.height;
    }
    else {
        height = 0.0f;
    }
    return height;
}

#pragma mark - 移除弹框视图
- (void)removeAlertView
{
    DH_WEAKSELF;
    //退出
    [UIView animateWithDuration:animateTime animations:^{
        weakSelf.alertBgView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [weakSelf.alertBgView removeFromSuperview];
        weakSelf.alertBgView = nil;
        weakSelf.operateView = nil;
    }];
}

- (void)okButtonClicked:(UIButton *)sender
{
    self.okBlock(nil);
    [self removeAlertView];
}

- (void)cancelButtonClicked:(UIButton *)sender
{
    [self removeAlertView];
}

- (void)neverShowBtn:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:_storeFlagStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeAlertView];
}

#pragma mark - lazy load
- (UIView *)alertBgView
{
    if (_alertBgView == nil) {
        _alertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight)];
        _alertBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _alertBgView.alpha = 0;
    }
    return _alertBgView;
}

- (UIView *)operateView
{
    if (_operateView == nil) {
        _operateView = [[UIView alloc] init];
        _operateView.backgroundColor = [UIColor whiteColor];
        _operateView.layer.cornerRadius = 6.0f;
        _operateView.clipsToBounds = YES;
    }
    return _operateView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:kSelfFontName size:titleFont];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont fontWithName:kSelfFontName size:detailFont];
        _detailLabel.textColor = [UIColor colorWithHexString:@"#555555"];
    }
    return _detailLabel;
}

- (UIButton *)okButton
{
    if (_okButton == nil) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.backgroundColor = [UIColor colorWithHexString:@"#dd3030"];
        _okButton.titleLabel.font = [UIFont fontWithName:kSelfFontName size:18];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _okButton.layer.masksToBounds = YES;
        _okButton.layer.cornerRadius = 5.0f;
        [_okButton addTarget:self action:@selector(okButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 5.0f;
        _cancelButton.layer.borderWidth = 1.0f;
        _cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#dd3030"].CGColor;
        _cancelButton.titleLabel.font = [UIFont fontWithName:kSelfFontName size:18];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#dd3030"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)neverShowBtn
{
    if (_neverShowBtn == nil) {
        _neverShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _neverShowBtn.titleLabel.font = [UIFont fontWithName:kSelfFontName size:15];
        [_neverShowBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_neverShowBtn setTitle:@"不再显示" forState:UIControlStateNormal];
        _neverShowBtn.layer.masksToBounds = YES;
        _neverShowBtn.layer.cornerRadius = 5.0f;
        [_neverShowBtn addTarget:self action:@selector(neverShowBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _neverShowBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
