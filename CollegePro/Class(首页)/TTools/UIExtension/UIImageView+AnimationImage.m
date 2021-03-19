//
//  UIImageView+AnimationImage.m
//  PresentTest
//
//  Created by Raymond~ on 2016/10/9.
//  Copyright © 2016年 Raymond~. All rights reserved.
//

#import "UIImageView+AnimationImage.h"
#import <sys/sysctl.h>
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import "SZKCleanCache.h"
static VoidBlock  animaitonDoneBlock;
static int currentIndex = 0;
static NSTimer * FR_timer;
static NSInteger FR_repeatCount;
static BOOL isAnimating = NO;
static NSRunLoop *runloop;
@implementation UIImageView (AnimationImage)
- (BOOL)FR_isAnimating
{
    
    return isAnimating;
}
- (void)FR_stopAnimating{
    isAnimating = NO;
    [FR_timer invalidate];
    FR_timer = nil;
    self.image = nil;
   
    runloop = nil;
    if (animaitonDoneBlock) {
        animaitonDoneBlock();
    }
}
- (void)FR_startAnimating{
    isAnimating = YES;
    [FR_timer fire];
    
}
- (void)animationImageNames:(NSArray *)imageNames
          animationDuration:(NSTimeInterval)animationDuration
                repeatCount:(NSInteger)repeatCount
                  doneBlock:(VoidBlock)doneBlock{
    currentIndex = 0;
    animaitonDoneBlock = doneBlock;
    FR_repeatCount = repeatCount;
    FR_timer = [NSTimer timerWithTimeInterval:animationDuration / imageNames.count target:self selector:@selector(changeImage:) userInfo:imageNames.copy repeats:YES];
    imageNames = nil;
    runloop=[NSRunLoop currentRunLoop];
    [runloop addTimer:FR_timer forMode:NSDefaultRunLoopMode];
    
}
- (void)changeImage:(NSTimer *)timer{
    
    NSArray * imageNames = timer.userInfo;;
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imageNames objectAtIndex:currentIndex] ofType:@"png"];
    UIImage *image = [UIImage imageNamed:[imageNames objectAtIndex:currentIndex]];
    self.image = image.copy;
    currentIndex ++;
    
    if (currentIndex >= imageNames.count - 1) {
        if (FR_repeatCount == 0) {
            currentIndex = 0;
        }else if(FR_repeatCount != 1){
            currentIndex = 0;
            FR_repeatCount --;
        }else{
            [timer invalidate];
            currentIndex = (int)imageNames.count - 1;
            imageNames = nil;
            self.image = nil;
//            [self removeFromSuperview];
            if (animaitonDoneBlock) {
                animaitonDoneBlock();
            }
        }
    }

//    self.image = nil;
}
- (void)dealloc{
//    [self FR_stopAnimating];
    //输出缓存大小 m
//    NSLog(@"%.2fm",[SZKCleanCache folderSizeAtPath]);
    
//    //清楚缓存
//    [SZKCleanCache cleanCache:^{
//        NSLog(@"清除成功");
//    }];
//    NSLog(@"AnimationImage dealloc %@",self);
}
@end
