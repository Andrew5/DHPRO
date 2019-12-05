//
//  UIViewController+VCDealloc.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "UIViewController+VCDealloc.h"
#import <objc/runtime.h>
#import "NSObject+DealBlock.h"
#import "WKVCDeallocManager.h"
#import "WKVCLifeCircleRecordManager.h"

static void *WKVCDeallocHelperKey;

@implementation UIViewController (VCDealloc)

+ (void)load
{
#ifdef DEBUG
    Method viewDidLoad = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method myViewDidLoad = class_getInstanceMethod([self class], @selector(wk_viewDidLoad));
    method_exchangeImplementations(viewDidLoad, myViewDidLoad);
    
    Method viewWillAppear = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method myViewWillAppear = class_getInstanceMethod([self class], @selector(wk_viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, myViewWillAppear);
    
    Method viewDidAppear = class_getInstanceMethod([self class], @selector(viewDidAppear:));
    Method myViewDidAppear = class_getInstanceMethod([self class], @selector(wk_viewDidAppear:));
    method_exchangeImplementations(viewDidAppear, myViewDidAppear);
    
    Method viewWillDisappear = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method myViewWillDisppear = class_getInstanceMethod([self class], @selector(wk_viewWillDisappear:));
    method_exchangeImplementations(viewWillDisappear, myViewWillDisppear);
    
    Method viewDidDisappear = class_getInstanceMethod([self class], @selector(viewDidDisappear:));
    Method myViewDidDisappear = class_getInstanceMethod([self class], @selector(wk_viewDidDisappear:));
    method_exchangeImplementations(viewDidDisappear, myViewDidDisappear);
    
    Method dismiss = class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:));
    Method myDismiss = class_getInstanceMethod([self class], @selector(wk_dismissViewControllerAnimated:completion:));
    method_exchangeImplementations(dismiss, myDismiss);
#endif
    
}

- (void)wk_viewDidLoad
{
    [self wk_viewDidLoad];
    [WKVCLifeCircleRecordManager addRecordWithVC:self methodName:[NSString stringWithFormat:@"%s",__func__]];

    //关键方法
    @synchronized (self) {
        @autoreleasepool {
            if (objc_getAssociatedObject(self, &WKVCDeallocHelperKey) == nil) {
                __unsafe_unretained typeof(self) weakSelf = self; // NOTE: need to be __unsafe_unretained because __weak var will be reset to nil in dealloc
                id deallocHelper = [self addDealBlock:^{
                    [WKVCDeallocManager removeWithObject:weakSelf];
                }];
                objc_setAssociatedObject(self, &WKVCDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
            }
        }
    }
    
}

- (void)wk_viewWillAppear:(BOOL)animation
{
    [WKVCLifeCircleRecordManager addRecordWithVC:self methodName:[NSString stringWithFormat:@"%s",__func__]];
    [self wk_viewWillAppear:animation];
}

- (void)wk_viewDidAppear:(BOOL)animation
{
    [WKVCLifeCircleRecordManager addRecordWithVC:self methodName:[NSString stringWithFormat:@"%s",__func__]];
    [WKVCDeallocManager addWithObject:self];
    [self wk_viewDidAppear:animation];
}

- (void)wk_viewWillDisappear:(BOOL)animation
{
    [WKVCLifeCircleRecordManager addRecordWithVC:self methodName:[NSString stringWithFormat:@"%s",__func__]];
    [self wk_viewWillDisappear:animation];
}

- (void)wk_viewDidDisappear:(BOOL)animation
{
    [WKVCLifeCircleRecordManager addRecordWithVC:self methodName:[NSString stringWithFormat:@"%s",__func__]];
    [self wk_viewDidDisappear:animation];
}

- (void)wk_dismissViewControllerAnimated:(BOOL)animation completion:(void (^ __nullable)(void))completion
{
    [WKVCDeallocManager releaseWithObject:self];
    [self wk_dismissViewControllerAnimated:animation completion:completion];
}

@end
