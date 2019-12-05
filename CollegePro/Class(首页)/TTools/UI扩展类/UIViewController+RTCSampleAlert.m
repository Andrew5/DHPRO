//
//  UIViewController+RTCSampleAlert.m
//  RtcSample
//
//  Created by daijian on 2019/2/28.
//  Copyright © 2019年 tiantian. All rights reserved.
//

#import "UIViewController+RTCSampleAlert.h"

@implementation UIViewController (RTCSampleAlert)

- (void)showAlertWithMessage:(NSString *)message handler:(nonnull void (^)(UIAlertAction * _Nonnull))handler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(action);
        }
    }];
    [alertController addAction:confirm];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}
+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

+ (id)getRootController
{
    UIWindow * wdw = [UIApplication sharedApplication].keyWindow;
    id rootVc = wdw.rootViewController;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * naviVC = (UINavigationController *)rootVc;
        return [naviVC topViewController];
    }else{
        return rootVc;
    }
}
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else {
        return rootViewController;
    }
}

+ (void)backToHostController:(UIView *)view
{
    
    UIViewController * viewcontroller = [self getPresentedViewController];
    if (!viewcontroller.navigationController.parentViewController) {
        [viewcontroller dismissViewControllerAnimated:NO completion:^{
            UIResponder *responder = view;
            NSMutableArray *arrayViewController = [[NSMutableArray alloc] init];
            UIViewController * vc;
            while ((responder = [responder nextResponder]))
            {
                if ([responder isKindOfClass: [UIViewController class]])
                {
                    vc = (UIViewController *)responder;
                    [arrayViewController addObject:vc];
                }
            }
            
            if (arrayViewController.count > 0) {
                UIViewController * vc = arrayViewController.lastObject;
                if (vc)
                {
                    if (vc.navigationController.parentViewController) {
                        [vc.navigationController popViewControllerAnimated:NO];
                    }else{
                        [vc dismissViewControllerAnimated:NO completion:^{
                            
                        }];
                    }
                }
                
            }
            
        }];
    }else{
        UIResponder *responder = view;
        NSMutableArray *arrayViewController = [[NSMutableArray alloc] init];
        UIViewController * vc;
        while ((responder = [responder nextResponder]))
        {
            if ([responder isKindOfClass: [UIViewController class]])
            {
                vc = (UIViewController *)responder;
                if (![vc isKindOfClass:[NSClassFromString(@"TLTabbarViewController") class]]) {
                    [arrayViewController addObject:vc];
                }
                
            }
        }
        
        if (arrayViewController.count > 0) {
            UIViewController * vc = arrayViewController.lastObject;
            if (vc)
            {
                if (vc.navigationController.parentViewController) {
                    [vc.navigationController popViewControllerAnimated:NO];
                }else{
                    [vc dismissViewControllerAnimated:NO completion:^{
                        
                    }];
                }
            }
            
        }
        
    }
}


+ (void)backToHostController:(UIView *)view viewController:(UIViewController *)vc
{
    if (vc.navigationController) {
        if (vc.navigationController.parentViewController) {
            [vc.navigationController popToRootViewControllerAnimated:NO];
        }else{
            [vc.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
        [vc dismissViewControllerAnimated:NO completion:nil];
    }
    
    UIResponder *responder = view;
    NSMutableArray *arrayViewController = [[NSMutableArray alloc] init];
   
    while ((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass: [UIViewController class]])
        {
            UIViewController *topVC = (UIViewController *)responder;
            if (![topVC isKindOfClass:[NSClassFromString(@"TLTabbarViewController") class]]) {
                [arrayViewController addObject:vc];
            }
            
        }
    }
    
    if (arrayViewController.count > 0) {
        UIViewController * vc = arrayViewController.lastObject;
        if (vc)
        {
            if (vc.navigationController.parentViewController) {
                [vc.navigationController popViewControllerAnimated:NO];
            }else{
                [vc dismissViewControllerAnimated:NO completion:^{
                    
                }];
            }
        }
        
    }

}
@end
