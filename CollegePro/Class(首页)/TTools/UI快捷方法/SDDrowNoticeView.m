//
//  SDDrowNoticeView.m
//  SpeedAcquisitionloan
//
//  Created by 李亚静 on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SDDrowNoticeView.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

// 判断是否为iPhone4
#define iPhone4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
// 判断是否为iPhone5
#define iPhone5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
// 判断是否为iPhone6
#define iPhone6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
// 判断是否为iPhone6 plus
#define iPhone6plus (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
// 判断是否为iPhone X
#define iPhone6plus (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define selfWith [UIScreen mainScreen].bounds.size.width
#define selfHeight 80.f
#define spaceToParentView 10
@interface SDDrowNoticeView()<UIGestureRecognizerDelegate,UIActionSheetDelegate>{
    
    UIWindow *wd;
}
@end

@implementation SDDrowNoticeView
+ (instancetype)createDrowNoticeView:(NSArray*)stringArray{
    
    SDDrowNoticeView *drowView = [[SDDrowNoticeView alloc] init:stringArray];

    drowView.frame = CGRectMake(0, DH_DeviceHeight>=812?-54:-selfHeight, selfWith, DH_DeviceHeight>=812?selfHeight:selfHeight);
    drowView.backgroundColor = [UIColor blackColor];

    return drowView;
}

- (instancetype)init:(NSArray*)arr{
    
    if ([super init]) {
        
        UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfWith, selfHeight)];
        backGroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:backGroundView];
        [self buildUI:arr inView:backGroundView];
        
        //遮盖状态栏方法
        wd = [self mainWindow];
        [wd addSubview:self];
        wd.windowLevel = UIWindowLevelAlert;
        
        //添加向上的轻扫手势
        UISwipeGestureRecognizer *swipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipaction:)];
        swipGR.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipGR];
        
        
    }return self;
    
}

/**
 获取window
 */
- (UIWindow*)mainWindow{
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

/**
 轻扫手势(向上)
 */
- (void)swipaction:(UISwipeGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self animationUP:0.15f delay:0.f];
    }
    
}

/**
 向下弹出动画
 */
- (void)animationDrown{
    
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint center = self.center;
        center.y += selfHeight;
        self.center = center;
    } completion:^(BOOL finished) {
        //延迟执行,避免过早删除
        [self performSelector:@selector(overs) withObject:nil afterDelay:10.0f];
        
    }];
    
}
- (void)overs{
    [self animationUP:0.3f delay:0.2f];
}

/**
 向上收回动画
 
 @param duration 动画时间
 @param durationDelay 延迟时间
 */
- (void)animationUP:(CGFloat)duration delay:(CGFloat)durationDelay{
    
    [UIView animateWithDuration:duration delay:durationDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center = self.center;
        center.y -= selfHeight;
        self.center = center;
    } completion:^(BOOL finished) {
        self->wd.windowLevel = UIWindowLevelNormal;
        [self removeFromSuperview];
    }];
}




/**
 构建UI
 
 @param arr 信息数据
 @param view 实例
 */
- (void)buildUI:(NSArray*)arr inView:(UIView*)view{
    //UI相关参数配置
    CGFloat titleSize = 14.f;
    CGFloat detailSize = 12.f;
    
//    if (iPhone4||iPhone5) {
//        titleSize = 16;
//        detailSize = 12;
//    }
//    if (iPhone6) {
//        titleSize = 17;
//        detailSize = 13;
//    }
//    if (iPhone6plus) {
//        titleSize = 17;
//        detailSize = 13;
//    }
    
    UIImage *appIcon;
    appIcon = [UIImage imageNamed:@"AppIcon60x60"];
    if (!appIcon) {
        appIcon = [UIImage imageNamed:@"AppIcon80x80"];
    }
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[self class]] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    
    
    //1系统icon
    UIImageView *iconImgView = [[UIImageView alloc] initWithImage:appIcon];
    [view addSubview:iconImgView];
    
    //2 App名
    UILabel *titleText = [[UILabel alloc] init];
    titleText.textColor = [UIColor whiteColor];
    titleText.text = appName;
    titleText.font = [UIFont systemFontOfSize:titleSize];
    [view addSubview:titleText];
    
    //3 传入的信息
    UILabel *detailText = [[UILabel alloc] init];
    detailText.text = [NSString stringWithFormat:@"%@\n%@",[arr firstObject],[arr lastObject]];
    detailText.font = [UIFont systemFontOfSize:detailSize];
    detailText.textColor = [UIColor whiteColor];
    detailText.numberOfLines = 2;
    [view addSubview:detailText];
    
    //4 now
    UILabel *nowText = [[UILabel alloc] init];
    nowText.font = [UIFont systemFontOfSize:titleSize-2];
    nowText.text = @"现在";
    nowText.textColor = [UIColor whiteColor];
    nowText.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:nowText];
    
    UIButton *btn_rowname = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_rowname.titleLabel.font = [UIFont systemFontOfSize:titleSize-2];
    [btn_rowname addTarget:self action:@selector(funtionTapWithAction:) forControlEvents:(UIControlEventTouchUpInside)];
    btn_rowname.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn_rowname setTitle:@"现在" forState:(UIControlStateNormal)];
    [btn_rowname setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:btn_rowname];
    
    //5 下方按钮
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    bottomView.layer.cornerRadius = spaceToParentView/3.f;
    bottomView.layer.masksToBounds = YES;
    bottomView.frame = CGRectMake(0, selfHeight-spaceToParentView, spaceToParentView*3, spaceToParentView/2);
    bottomView.center = CGPointMake(selfWith/2, selfHeight - spaceToParentView/2);
    [view addSubview:bottomView];
    
    
    //UI相关frame设置
    iconImgView.frame = CGRectMake(spaceToParentView, spaceToParentView, appIcon.size.width/2, appIcon.size.height/2);
    
    CGFloat titleTextToIconImageView = spaceToParentView + iconImgView.frame.size.width + spaceToParentView;
    CGFloat titleTextHeight = [self heightForString:titleText andWidth:titleSize];
    CGFloat titleTextWidth  = selfWith - 2*titleTextToIconImageView;
    titleText.frame    = CGRectMake(titleTextToIconImageView, spaceToParentView, titleTextWidth, titleTextHeight);
    
    CGFloat detailTextHeight = [self heightForString:detailText andWidth:detailSize];
    CGFloat detailTextX = spaceToParentView + titleTextHeight + 0;
    detailText.frame =  CGRectMake(titleTextToIconImageView,detailTextX , titleTextWidth, detailTextHeight);
    
//    nowText.frame = CGRectMake(CGRectGetMaxX(detailText.frame)+spaceToParentView, 0, titleTextToIconImageView, titleTextHeight);
    btn_rowname.frame = CGRectMake(CGRectGetMaxX(detailText.frame), 20, titleTextToIconImageView, titleTextHeight);
    CGPoint centen = nowText.center;
    centen.y = selfHeight/2;
    nowText.center = centen;
    
    
    
}
- (void)funtionTapWithAction:(UIButton *)btn{
     [self removeFromSuperview];
}
/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UILabel *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
