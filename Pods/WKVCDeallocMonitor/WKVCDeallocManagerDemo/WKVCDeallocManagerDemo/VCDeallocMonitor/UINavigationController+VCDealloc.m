//
//  UINavigationController+VCDealloc.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "UINavigationController+VCDealloc.h"
#import "WKVCDeallocManager.h"
#import <objc/runtime.h>
@implementation UINavigationController (VCDealloc)

+ (void)load
{
#ifdef DEBUG
    Method popv = class_getInstanceMethod([self class], @selector(popViewControllerAnimated:));
    Method mypopv = class_getInstanceMethod([self class], @selector(wk_popViewControllerAnimated:));
    method_exchangeImplementations(popv, mypopv);
    
    Method poptv = class_getInstanceMethod([self class], @selector(popToViewController:animated:));
    Method mypoptv = class_getInstanceMethod([self class], @selector(wk_popToViewController:animated:));
    method_exchangeImplementations(poptv, mypoptv);
    
    
    Method popTR = class_getInstanceMethod([self class], @selector(popToRootViewControllerAnimated:));
    Method myPopTR = class_getInstanceMethod([self class], @selector(wk_popToRootViewControllerAnimated:));
    method_exchangeImplementations(popTR, myPopTR);
#endif
}

- (UIViewController *)wk_popViewControllerAnimated:(BOOL)animated
{
    UIViewController * vc = [self wk_popViewControllerAnimated:animated];
    [WKVCDeallocManager releaseWithObject:vc];
    return vc;
}

- (NSArray<UIViewController *> *)wk_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray * vcs = [self wk_popToViewController:viewController animated:animated];
    for (UIViewController * vc in vcs) {
        [WKVCDeallocManager releaseWithObject:vc];
    }
    return vcs;
}

- (NSArray<UIViewController *> *)wk_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray * vcs = [self wk_popToRootViewControllerAnimated:animated];
    for (UIViewController * vc in vcs) {
        [WKVCDeallocManager releaseWithObject:vc];
    }
    return vcs;
}

@end
