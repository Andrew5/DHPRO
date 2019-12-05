//
//  LLBlurSidebar.m
//  Gaoguan
//
//  Created by lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "LLBlurSidebar.h"
#import <Accelerate/Accelerate.h>

//#define LLDEBUG
#ifdef LLDEBUG
#define LLLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define LLLog(format, ...)
#endif

#define LL_IS_IOS_6_OR_EARLIER [[UIDevice currentDevice] systemVersion].floatValue < 7.0

#define duration 0.3


@interface LLBlurSidebar () <UIGestureRecognizerDelegate>
{
    CGPoint startTouchPotin; // 手指按下时的坐标
    CGFloat startContentOriginX; // 移动前的窗口位置
    BOOL _isMoving;
    
    float red;
    float green;
    float blue;
}

@property (nonatomic, retain) UIImageView* snapImageView;
@property (nonatomic, retain) UIView* blurView;

@end


@implementation LLBlurSidebar


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.snapImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//	self.snapImageView.image = [UIImage imageNamed:@"组-3"];
    self.snapImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.snapImageView]; // 暂时不用它,以后可以用作固定背景
	
    self.blurView = [[[UIView alloc] initWithFrame:self.view.bounds] autorelease];
    self.blurView.userInteractionEnabled = NO;
    [self.view addSubview:self.blurView];
    self.blurView.alpha = 0; // 一开始不显示
    if (LL_IS_IOS_6_OR_EARLIER) { // for ios6
        CGRect rect6 = self.blurView.frame;
        rect6.origin.y = -20;
        rect6.size.height += 20;
        [self.blurView setFrame:rect6];
    }
    
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)] autorelease];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    // 列表
    CGRect rect = CGRectMake(-kSidebarWidth, 0, kSidebarWidth, self.view.bounds.size.height);
    self.contentView = [[[UIView alloc] initWithFrame:rect] autorelease];
    [self.view addSubview:self.contentView];
//	[[UIApplication sharedApplication].keyWindow addSubview:self.contentView];
    
    self.view.hidden = YES;
}

- (void)dealloc{
    [self.snapImageView release];
    self.snapImageView = nil;
    [self.blurView release];
    self.blurView = nil;
    [self.contentView release];
    self.contentView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 显示/隐藏
- (BOOL)isSidebarShown{
    return self.contentView.frame.origin.x > -kSidebarWidth ? YES :NO;
}

- (void)showHideSidebar
{
    if (self.contentView.frame.origin.x == -kSidebarWidth) {
        LLLog(@"开始时在-点");
        [self beginShowSidebar]; // step1
    }
    [self autoShowHideSidebar]; // step2
}

#pragma mark 子类中可用的
- (void)slideToRightOccured
{
    LLLog(@"触发了右滑事件，需要时可以在子类中用");
}

- (void)sidebarDidShown
{
    LLLog(@"已经完成显示，需要时可以在子类中用");
}

#pragma mark Private
- (void)autoShowHideSidebar
{
    if (!self.isSidebarShown)
    {
        LLLog(@"自动弹出");
        self.view.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            [self sidebarDidShown];
        }];
    }
    else
    {
        LLLog(@"自动缩回");
        [UIView animateWithDuration:duration animations:^{
            [self setSidebarOriginX:-kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
    }
}

- (void)beginShowSidebar
{
    // 记录按下时的x位置
    startContentOriginX = self.contentView.frame.origin.x;
    
    if (self.contentView.frame.origin.x < 0) { //self.blurView.alpha < 0.5 &&
        
        // 截图
        self.snapImageView.image = [self imageFromView:self.view.superview];
        
        __block typeof(self) bself = self;
        dispatch_queue_t queue = dispatch_queue_create("cn.lugede.LLBlurSidebar", NULL);
        dispatch_async(queue, ^ {
            
            UIImage *blurImage = [self blurryImage:bself.snapImageView.image withBlurLevel:0.2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                bself.blurView.layer.contents = (id)blurImage.CGImage;
                LLLog(@"Blur Success !~~~~~~~~~~~~~~~~~");
            });
        });
        dispatch_release(queue);
        
    }
}

#pragma mark - 手势响应
- (void)tapDetected:(UITapGestureRecognizer*)recognizer
{
    [self autoShowHideSidebar];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if (point.x < kSidebarWidth) {
        return NO;
    }
    return  YES;
}

// 仅供判断右滑
- (void)panDetectedForBack:(UIPanGestureRecognizer *)recoginzer
{
    LLLog(@"\n slide Detected");
    
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    CGFloat offsetX = touchPoint.x - startTouchPotin.x;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        LLLog(@"┌ slide Begin point = %f", touchPoint.x);
        startTouchPotin = touchPoint;
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        LLLog(@"└ slide End");
        
        if (offsetX > 40) // 右滑大于40
        {
            [self slideToRightOccured];
        }
        return;
    }
}

- (void)panDetected:(UIPanGestureRecognizer *)recoginzer
{
    LLLog(@"\n pan Detected");
    
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    CGFloat offsetX = touchPoint.x - startTouchPotin.x;
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        LLLog(@"┌ Pan Begin point = %f", touchPoint.x);
        
        _isMoving = YES;
        startTouchPotin = touchPoint;
        
        self.view.hidden = NO;
        [self beginShowSidebar];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        LLLog(@"└ Pan End");
        
        if (offsetX > 40 || ((int)startContentOriginX==0 && offsetX<0 && offsetX>-20)) // 右滑大于40，或展开时左滑一丁点
        {
            [self slideToRightOccured]; // 即将显示到底
            
            LLLog(@"显示到底----->");
            self.view.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                [self setSidebarOriginX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                [self sidebarDidShown];
            }];
        }
        else
        {
            LLLog(@"<-----隐藏到底");
            [UIView animateWithDuration:0.3 animations:^{
                [self setSidebarOriginX:-kSidebarWidth];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.view.hidden = YES;
            }];
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        LLLog(@"Pan Cancelled");
        [UIView animateWithDuration:0.3 animations:^{
            [self setSidebarOriginX:-kSidebarWidth];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.view.hidden = YES;
        }];
        return;
    }
    
    if (_isMoving) {
        [self setSidebarOffset:offsetX];
        LLLog(@"Moving …… touch=%f, offset=%f", touchPoint.x, offsetX);
    }
    
}

#pragma mark - 侧栏出来
/*
 * 设置侧栏位置
 * 完全不显示时为x=-kSidebarWidth，显示到最右时x=0
 */
- (void)setSidebarOriginX:(CGFloat)x
{
    CGRect rect = self.contentView.frame;
    rect.origin.x = x;
    [self.contentView setFrame:rect];
    
    [self setBlurViewAlpha];
}

/*
 * 设置侧栏相对于开始点击时的偏移
 * offset>0向右，offset<0向左
 */
- (void)setSidebarOffset:(CGFloat)offset
{
    LLLog(@"startContentOriginX = %f", startContentOriginX);
    CGRect rect = self.contentView.frame;
    
    if (offset >=0) { // 右滑
        // 如果不在最右
        if (rect.origin.x<0) {
            rect.origin.x = startContentOriginX + offset; // 直接向右偏移这么多
            if (rect.origin.x > 0) {
                rect.origin.x = 0;
            }
        }
    } else { // 左滑
        // 如果不在最左
        if (rect.origin.x > -kSidebarWidth) {
            rect.origin.x = startContentOriginX + offset;
            if (rect.origin.x < -kSidebarWidth) {
                rect.origin.x = -kSidebarWidth;
            }
        }
    }
    [self.contentView setFrame:rect];
    [self setBlurViewAlpha];
    
}

// 之所以分开是为了动画时渐变
- (void)setBlurViewAlpha
{
    CGRect rect = self.contentView.frame;
    float percent = (kSidebarWidth + rect.origin.x) / kSidebarWidth;
    self.blurView.alpha = percent = 0.2 + (1-0.2)*(percent); // 不从0开始，效果更明显
    //    self.blurView.alpha = percent;
    LLLog(@"blur alpha = %f", percent);
    
    percent = 0.7 + (0.8-0.7)*(percent);
    self.contentView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:percent];
}

- (void)setBgRGB:(long)rgb
{
    red = ((float)((rgb & 0xFF0000) >> 16))/255.0;
    green = ((float)((rgb & 0xFF00) >> 8))/255.0;
    blue = ((float)(rgb & 0xFF))/255.0;
}

#pragma mark - Blur
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        LLLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
