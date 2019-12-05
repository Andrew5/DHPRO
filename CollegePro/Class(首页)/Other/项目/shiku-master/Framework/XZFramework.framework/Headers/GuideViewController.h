//
//  GuidViewController.h
//  btc
//
//  Created by txj on 15/1/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
{
    BOOL _animating;
    
    UIScrollView *_pageScroll;
    NSArray *imageNameArray;
}

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

+ (GuideViewController *)sharedGuide;
+ (GuideViewController *)sharedGuide:(NSArray *)imageNames;

+ (void)show;
+ (void)show:(NSArray *)imageNames;
+ (void)hide;

-(instancetype)initWithImageNameArray:(NSArray *)imageNames;
- (void)showGuide;
- (void)hideGuide;

@end
