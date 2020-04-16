//
//  CustomAlertView.m
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIColor+ChangeNColor.h"
#import "UIView+Animation.h"
#define superid_ad_color_title          HEXRGB(0x0099cc)
#define superid_ad_color_tips           HEXRGB(0x333333)

//RGB Color transform（16 bit->10 bit）
#define HEXRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define   isIphone4  [UIScreen mainScreen].bounds.size.height < 500

#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)
//Get View size:
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)
@interface CustomAlertView()

@property(retain, nonatomic) IBOutletCollection(NSObject) NSArray* superid_ad_closeTargets;
@property(retain,nonatomic) UIButton        *closeBtn;
@property(strong,nonatomic) UIButton        *chooseBtn;
@property(retain,nonatomic) UIView          *bgView;
@property(retain,nonatomic) UIImageView     *adImageView;
@property(retain,nonatomic) NSDictionary    *characterDitionary;

@end
@implementation CustomAlertView

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.backgroundColor = [UIColor clearColor];
        //遮罩背景
        UIView *maskView = ({
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.7;
            view;
        });
        [self addSubview:maskView];
        //Root背景
        _bgView = ({
            
            UIView *view =[[UIView alloc]initWithFrame: CGRectMake(0, 0, 0.8*SCREENWIDTH, 0.8*SCREENWIDTH/0.64)];
//            view.frame = CGRectMake(0, 0, 0.8125*SCREENWIDTH, 1.46*0.825*SCREENWIDTH);
            view.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
            if (isIphone4) {
                
                self.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2+20);
            }
            view.backgroundColor = [UIColor clearColor];
            view.layer.cornerRadius = 6.0;
            view.clipsToBounds = YES;
//            view.layer.borderWidth=1;
//            view.layer.borderColor=superid_ad_color_title.CGColor;
            view;
            
        });
        
        [self addSubview:_bgView];
        //关闭按钮
        _closeBtn = ({
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];;
            btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 50, 33, 33);
            if (isIphone4) {
                
                btn.frame = CGRectMake(VIEW_BX(_bgView)-32, 12, 33, 33);
                
            }
            btn.center = CGPointMake(self.center.x, _bgView.tz_bottom+33);

            [btn setBackgroundImage:[self imageOfSuperid_ad_close] forState:normal];
            [btn addTarget:self action:@selector(closeBtnClickEventHandle) forControlEvents:UIControlEventTouchUpInside];
            
            btn;
        });
        
        [self addSubview:_closeBtn];
        //图片背景
        _adImageView = ({
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_W(_bgView), VIEW_H(_bgView) )];
            view;
            
        });
        [_bgView addSubview:_adImageView];
        //按钮
        _chooseBtn = ({
            UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseBtn setFrame:CGRectMake(0, VIEW_H(_adImageView)-50, VIEW_W(_bgView), 50)];
            chooseBtn.backgroundColor = [UIColor colorWithHexString:@"#fd7a3b"];
            chooseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            chooseBtn.titleLabel.font = Font14;
            [chooseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            chooseBtn.layer.borderColor = [UIColor colorWithHexString:@"#fd7a3b"].CGColor;
            chooseBtn.layer.borderWidth = 1.0;
            chooseBtn.layer.cornerRadius = 5.0;
            [chooseBtn setTitle:@"更多精彩" forState:UIControlStateNormal];
            chooseBtn;
        });
        
//        [_bgView addSubview:_chooseBtn];
        
    }
    return self;
    
}
- (void)functionWithClick:(UITapGestureRecognizer *)btn{
    [self removeFromSuperview];
//    [[UIApplication sharedApplication].keyWindow removeFromSuperview];
//    [[UIApplication sharedApplication].keyWindow setHidden:YES];
    _clickFuntion();
}
- (void)showInView:(UIView *)view withFaceInfo: (NSDictionary *)info advertisementImage: (NSString *)imageurl borderColor: (UIColor *)color{
    
    if (!info[@"link"]) {
        _chooseBtn.hidden = YES;
        return;
    }else{
        _chooseBtn.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(functionWithClick:)];
        [_bgView addGestureRecognizer:tap];
//        [_chooseBtn addTarget:self action:@selector(functionWithClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [self dh_animation_scaleShowWithDuration:0.3 ratio:1.1 finishBlock:^{

    }];
   
    if (color) {
        
        _bgView.layer.borderColor = color.CGColor;
        
    }
    [view addSubview:self];
    
 
}
- (void)closeBtnClickEventHandle{
    [self dh_animation_scaleDismissWithDuration:0.3 ratio:1.1 finishBlock:^{
        [self removeFromSuperview];
        _adImageView.image = nil;
    }];
    
    
}
#pragma mark Generated Images
static UIImage* _imageOfSuperid_ad_close = nil;

- (UIImage*)imageOfSuperid_ad_close
{
    if (_imageOfSuperid_ad_close)
        return _imageOfSuperid_ad_close;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(64, 64), NO, 0.0f);
    [self drawSuperid_ad_close];
    
    _imageOfSuperid_ad_close = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return _imageOfSuperid_ad_close;
}
- (void)drawSuperid_ad_close
{
    //// Color Declarations
    UIColor* white = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// yuan Drawing
    UIBezierPath* yuanPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2, 2, 60, 61)];
    [white setStroke];
    yuanPath.lineWidth = 2;
    [yuanPath stroke];
    
    
    //// mid Drawing
    UIBezierPath* midPath = UIBezierPath.bezierPath;
    [midPath moveToPoint: CGPointMake(30.01, 32.5)];
    [midPath addLineToPoint: CGPointMake(18.74, 43.96)];
    [midPath addCurveToPoint: CGPointMake(18.74, 45.98) controlPoint1: CGPointMake(18.2, 44.51) controlPoint2: CGPointMake(18.19, 45.42)];
    [midPath addCurveToPoint: CGPointMake(20.73, 45.98) controlPoint1: CGPointMake(19.29, 46.54) controlPoint2: CGPointMake(20.18, 46.54)];
    [midPath addLineToPoint: CGPointMake(32, 34.52)];
    [midPath addLineToPoint: CGPointMake(43.27, 45.98)];
    [midPath addCurveToPoint: CGPointMake(45.26, 45.98) controlPoint1: CGPointMake(43.82, 46.54) controlPoint2: CGPointMake(44.71, 46.54)];
    [midPath addCurveToPoint: CGPointMake(45.26, 43.96) controlPoint1: CGPointMake(45.81, 45.42) controlPoint2: CGPointMake(45.8, 44.51)];
    [midPath addLineToPoint: CGPointMake(33.99, 32.5)];
    [midPath addLineToPoint: CGPointMake(45.26, 21.04)];
    [midPath addCurveToPoint: CGPointMake(45.26, 19.02) controlPoint1: CGPointMake(45.8, 20.49) controlPoint2: CGPointMake(45.81, 19.58)];
    [midPath addCurveToPoint: CGPointMake(43.27, 19.02) controlPoint1: CGPointMake(44.71, 18.46) controlPoint2: CGPointMake(43.82, 18.46)];
    [midPath addLineToPoint: CGPointMake(32, 30.48)];
    [midPath addLineToPoint: CGPointMake(20.73, 19.02)];
    [midPath addCurveToPoint: CGPointMake(18.74, 19.02) controlPoint1: CGPointMake(20.18, 18.46) controlPoint2: CGPointMake(19.29, 18.46)];
    [midPath addCurveToPoint: CGPointMake(18.74, 21.04) controlPoint1: CGPointMake(18.19, 19.58) controlPoint2: CGPointMake(18.2, 20.49)];
    [midPath addLineToPoint: CGPointMake(30.01, 32.5)];
    [midPath closePath];
    midPath.miterLimit = 4;
    
    midPath.usesEvenOddFillRule = YES;
    
    [white setFill];
    [midPath fill];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
