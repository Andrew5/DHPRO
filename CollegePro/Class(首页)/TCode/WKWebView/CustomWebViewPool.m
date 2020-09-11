//
//  CustomWebViewPool.m
//  NetworkRequestDemo
//
//  Created by admin on 2020/6/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CustomWebViewPool.h"
@interface CustomWebViewPool()
@property (nonatomic) NSUInteger initialViewsMaxCount;  //最多初始化的个数
@property (nonatomic) NSMutableArray *preloadedViews;

@end
@implementation CustomWebViewPool
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CustomWebViewPool *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.initialViewsMaxCount = 20;
        self.preloadedViews = [NSMutableArray arrayWithCapacity:self.initialViewsMaxCount];
    }
    return self;
}

/**
 预初始化若干WKWebView
 
 @param count 个数
 */
- (void)prepareWithCount:(NSUInteger)count {
    
    NSTimeInterval start = CACurrentMediaTime();
    
    // Actually does nothing, only initialization must be called.
    while (self.preloadedViews.count < MIN(count,self.initialViewsMaxCount)) {
        id preloadedView = [self createPreloadedView];
        if (preloadedView) {
            [self.preloadedViews addObject:preloadedView];
        } else {
            break;
        }
    }
    
    NSTimeInterval delta = CACurrentMediaTime() - start;
    NSLog(@"=======初始化耗时：%f",  delta);
}

/**
 从池中获取一个WKWebView
 @return WKWebView
 */
- (CustomWebView *)getWKWebViewFromPool {
    if (!self.preloadedViews.count) {
        NSLog(@"不够啦！");
        return [self createPreloadedView];
    } else {
        id preloadedView = self.preloadedViews.firstObject;
        [self.preloadedViews removeObject:preloadedView];
        return preloadedView;
    }
}

/**
 创建一个WKWebView
 @return WKWebView
 */
- (CustomWebView *)createPreloadedView {
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    CustomWebView *wkWebView = [[CustomWebView alloc]initWithFrame:CGRectZero configuration:wkWebConfig];
    //根据自己的业务需求初始化WKWebView
    wkWebView.opaque = NO;
    wkWebView.scrollView.scrollEnabled = YES;
    wkWebView.scrollView.showsVerticalScrollIndicator = YES;
    wkWebView.scrollView.scrollsToTop = YES;
    wkWebView.scrollView.userInteractionEnabled = YES;
    if (@available(iOS 11.0,*)) {
        wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    wkWebView.scrollView.bounces = NO;
    wkWebView.backgroundColor = [UIColor clearColor];
    
    return wkWebView;
}
@end
