//
//  RecordHUD.m
//  D3RecordButtonDemo
//
//  Created by bmind on 15/7/29.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import "RecordHUD.h"

@implementation RecordHUD

@synthesize overlayWindow;

+ (RecordHUD*)shareView{
    static dispatch_once_t once;
    static RecordHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[RecordHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show{
    [[RecordHUD shareView] show];
}


- (void)show{
        if(!self.superview){
            [self.overlayWindow addSubview:self];
        }
        
        imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mic_0.png"]];
        imgView.frame = CGRectMake(0, 0, 154, 180);
        imgView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
        imgView.layer.cornerRadius = 10.0f;
        imgView.clipsToBounds = YES;
        
        
        if (!titleLabel){
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
            titleLabel.backgroundColor = [UIColor clearColor];
        }
        titleLabel.center = CGPointMake(imgView.center.x, imgView.center.y + 65);
        titleLabel.text = @"离开按钮取消录音";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        
        if (!timeLabel) {
            timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
            timeLabel.backgroundColor = [UIColor clearColor];
        }
        timeLabel.center = CGPointMake(imgView.center.x, imgView.center.y - 77);
        timeLabel.text = @"录音: 0\"";
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont boldSystemFontOfSize:14];
        timeLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:imgView];
        [self addSubview:titleLabel];
        [self addSubview:timeLabel];
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
}


+ (void)dismiss{
    [[RecordHUD shareView]dismiss];
}

- (void)dismiss{
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [imgView removeFromSuperview];
                                 imgView = nil;
                                 [titleLabel removeFromSuperview];
                                 titleLabel.text = nil;
                                 [timeLabel removeFromSuperview];
                                 timeLabel.text = nil;
                                 
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
}


+(void)setTitle:(NSString *)title{
    [[RecordHUD shareView]setTitle:title];
}

- (void)setTitle:(NSString *)title{
    if (titleLabel) {
        titleLabel.text = title;
    }
}

+(void)setTimeTitle:(NSString *)time{
    [[RecordHUD shareView]setTimeTitle:time];
}

- (void)setTimeTitle:(NSString *)time{
    if (timeLabel) {
        timeLabel.text = time;
    }
}

+(void)setImage:(NSString *)imgName{
    [[RecordHUD shareView]setImage:imgName];
}

-(void)setImage:(NSString *)imgName{
    if (imgView) {
        imgView.image = [UIImage imageNamed:imgName];
    }
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}
@end
