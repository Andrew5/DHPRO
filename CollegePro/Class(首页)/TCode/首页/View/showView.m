//
//  showView.m
//  15
//
//  Created by 奇葩网络 on 2017/5/27.
//  Copyright © 2017年 大爷公司. All rights reserved.
//

#import "showView.h"

@interface showView ()

+ (instancetype)instance;

@property (nonatomic ,strong) UIImageView *_img;
@property (nonatomic ,strong) UIWindow *_window;
@property (nonatomic ,strong) UIButton *_btn;

@end

@implementation showView

static showView *instance;

+ (instancetype)instance
{
    if (!instance)
    {
        instance = [[showView alloc] init];
    }
    return instance;
}

- (instancetype)init
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight)]))
    {
        self.backgroundColor = [UIColor clearColor];
        if (self.window == nil)
        {
            self._window = [[UIWindow alloc] init];
            self._window.frame = self.frame;
            self._window.windowLevel = UIWindowLevelAlert+1;
            self._window.backgroundColor = [UIColor blackColor];
            self._window.alpha = .5;
            [self._window addSubview:self];
            [self._window makeKeyAndVisible];
        }
        
        self._img = [[UIImageView alloc] init];
        self._img.frame = CGRectMake(20, 100, self.frame.size.width-40, self.frame.size.height-200);
        [self addSubview:self._img];
        
        self._btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self._btn.backgroundColor = [UIColor blueColor];
        self._btn.frame = CGRectMake((self.frame.size.width - 100)/2, self.frame.size.height - 75, 100, 50);
        [self._btn setTitle:@"点击" forState:UIControlStateNormal];
        [self._btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self._btn];
        
    }
    return self;
}


+ (void)showWelcomeView:(UIImage *)images
{
    [self instance];
    instance._img.image = images;
}

- (void)dismissView
{
    [self removeFromSuperview];
    instance = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
