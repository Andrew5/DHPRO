//
//  UINavigationController+DHLeak.m
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "UINavigationController+DHLeak.h"
#import "SwizzManager.h"
#import "UIViewController+DHLeak.h"

@implementation UINavigationController (DHLeak)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{///交换时机方法pop
        SEL originSel = @selector(popViewControllerAnimated:);
        SEL newSel = @selector(dh_popViewControllerAnimated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel newSel:newSel];
        SEL originSel1 = @selector(popToViewController:animated:);
        SEL newSel1 = @selector(dh_popToViewController:animated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel1 newSel:newSel1];
        SEL originSel2 = @selector(popToRootViewControllerAnimated:);
        SEL newSel2 = @selector(dh_popToRootViewControllerAnimated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel2 newSel:newSel2];
        
    });
}
///pop 设置标识
-(UIViewController *)dh_popViewControllerAnimated:(BOOL)animated{
    
    UIViewController* viewController = [self dh_popViewControllerAnimated:animated];
    viewController.isDeallocDisappear = YES;
    return viewController;
}
/// 拿到被pop的viewControllers，依次调用延时任务
-(NSArray<UIViewController *> *)dh_popToRootViewControllerAnimated:(BOOL)animated{
    
    NSArray<UIViewController *> * viewControllers = [self dh_popToRootViewControllerAnimated:animated];
    for (UIViewController* vc in viewControllers) {
        [vc willDealloc];
    }
    return viewControllers;
}
/// 拿到被pop的viewControllers，依次调用延时任务
-(NSArray<UIViewController *> *)dh_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray<UIViewController *> * viewControllers = [self dh_popToViewController:viewController animated:animated];
    for (UIViewController* vc in viewControllers) {
        [vc willDealloc];
    }
    return viewControllers;
}
@end
