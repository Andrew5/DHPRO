//
//  DoraemonMockGPSOperateView.m
//  DoraemonKit-DoraemonKit
//
//  Created by yixiang on 2018/12/2.
//

#import "DoraemonMockGPSOperateView.h"
#import "DoraemonDefine.h"

@interface DoraemonMockGPSOperateView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DoraemonMockGPSOperateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemBackgroundColor];
        } else {
#endif
            self.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        self.layer.cornerRadius = kDoraemonSizeFrom750_Landscape(8);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(32)];
        _titleLabel.textColor = [UIColor doraemon_black_1];
        _titleLabel.text = DoraemonLocalizedString(@"打开Mock GPS");
        [self addSubview:_titleLabel];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake(kDoraemonSizeFrom750_Landscape(32), self.doraemon_height/2-_titleLabel.doraemon_height/2, _titleLabel.doraemon_width, _titleLabel.doraemon_height);
        
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = [UIColor doraemon_blue];
        _switchView.doraemon_origin = CGPointMake(self.doraemon_width-kDoraemonSizeFrom750_Landscape(32)-_switchView.doraemon_width, self.doraemon_height/2-_switchView.doraemon_height/2);
        [self addSubview:_switchView];
    }
    return self;
}

@end
