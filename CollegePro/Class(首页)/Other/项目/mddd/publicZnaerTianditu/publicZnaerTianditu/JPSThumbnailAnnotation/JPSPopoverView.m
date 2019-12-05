//
//  PopoverView.m
//  ArrowView
//
//  Created by guojiang on 4/9/14.
//  Copyright (c) 2014年 LINAICAI. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


#import "JPSPopoverView.h"

#define kArrowHeight 10.f
#define kArrowCurvature 6.f
#define SPACE 2.f
#define TITLE_FONT [UIFont systemFontOfSize:16]

#define HEIGHT 90
#define WIDTH 130

#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface JPSPopoverView ()

@property (nonatomic) CGPoint showPoint;

@property (nonatomic, strong) UIButton *handerView;

@property (nonatomic)NSInteger selectedIndex;

@end

@implementation JPSPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.borderColor = RGB(252, 230, 201);
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(id)initWithPoint:(CGPoint)point
{
    self = [super init];
    if (self) {
        self.showPoint = point;
        
        self.frame = [self getViewFrame];
        
        [self addSubview:[self getPopView]];
        
        self.alpha = 0.8f;
        
    }
    return self;
}

- (UIView *)getPopView{
   
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
   
    UIButton *addPeopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPeopleBtn.frame = CGRectMake(0, 16, WIDTH, 30);
    [addPeopleBtn setImage:[UIImage imageNamed:@"add_user.png"] forState:UIControlStateNormal];
    [addPeopleBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    addPeopleBtn.titleLabel.font = TITLE_FONT;
    [addPeopleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addPeopleBtn.tag = 100;
    [addPeopleBtn addTarget:self action:@selector(onSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    addPeopleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    addPeopleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [view addSubview:addPeopleBtn];

    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(0, 50, WIDTH, 30);
    [codeBtn setImage:[UIImage imageNamed:@"saomiao.png"] forState:UIControlStateNormal];
    [codeBtn setTitle:@"扫一扫 " forState:UIControlStateNormal];
    codeBtn.titleLabel.font = TITLE_FONT;
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.tag = 200;
    [codeBtn addTarget:self action:@selector(onSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    codeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    [view addSubview:codeBtn];

    
    return view;
}

- (void)onSelectedAction:(UIButton *)btn{
   
    int index = (btn.tag == 100 ? 0 : 1);
    
    if (self.selectItemAtIndex)
        self.selectItemAtIndex(index);
   
    [self dismiss:YES];
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    
    frame.size.height = HEIGHT;
    
    frame.size.width = WIDTH;
    
    frame.origin.x = self.showPoint.x - frame.size.width + 10;
    frame.origin.y = self.showPoint.y;
    
//    //左间隔最小5x
//    if (frame.origin.x < 10) {
//        frame.origin.x = 10;
//    }
    //右间隔最小5x
//    if ((frame.origin.x + frame.size.width) > 315) {
//        frame.origin.x = 315 - frame.size.width - 10;
//    }
    
    return frame;
}


-(void)show
{
    self.handerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handerView setFrame:[UIScreen mainScreen].bounds];
    [_handerView setBackgroundColor:[UIColor clearColor]];
    [_handerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_handerView addSubview:self];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:_handerView];
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / self.frame.size.width, arrowPoint.y / self.frame.size.height);
    self.frame = [self getViewFrame];
    
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

-(void)dismiss
{
    [self dismiss:YES];
}

-(void)dismiss:(BOOL)animate
{
    if (!animate) {
        [_handerView removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_handerView removeFromSuperview];
    }];
    
}





// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.borderColor set]; //设置线条颜色
    
    CGRect frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height - kArrowHeight);
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    CGPoint arrowPoint = [self convertPoint:self.showPoint fromView:_handerView];
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];

    [popoverPath moveToPoint:CGPointMake(xMin, yMin)];//左上角
    
    /********************向上的箭头**********************/
    [popoverPath addLineToPoint:CGPointMake(arrowPoint.x - kArrowHeight, yMin)];//left side
    [popoverPath addCurveToPoint:arrowPoint
                   controlPoint1:CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin)
                   controlPoint2:arrowPoint];//actual arrow point
    
    [popoverPath addCurveToPoint:CGPointMake(arrowPoint.x + kArrowHeight, yMin)
                   controlPoint1:arrowPoint
                   controlPoint2:CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    /********************向上的箭头**********************/
    
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMin)];//右上角
    
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax)];//右下角
    
    [popoverPath addLineToPoint:CGPointMake(xMin, yMax)];//左下角
    
    //填充颜色
    [RGB(46, 135, 238) setFill];
    [popoverPath fill];
    
    [popoverPath closePath];
    [popoverPath stroke];
}


@end
