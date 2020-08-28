//
//  UIViewController+topmost.m
//  JHUniversalApp
//
//  Created by  William Sterling on 15/8/3.
//  Copyright (c) 2015年  William Sterling. All rights reserved.
//


#import "UIViewController+topmost.h"
#import <objc/runtime.h>

@implementation UIViewController (topmost)


- (void) swizzle_viewDidLoad {
    [self swizzle_viewDidLoad];
    
    IMP instanceForDoSomething = [UIViewController instanceMethodForSelector:@selector(dosSomethingWith)];
    void (*func)(id,SEL,...) = (void *)instanceForDoSomething;
    func(self,@selector(dosSomethingWith));
}

+ (void)load{
    [super load];

    Method original, swizzled;
    original = class_getInstanceMethod(self, @selector(viewDidLoad));
    swizzled = class_getInstanceMethod(self, @selector(swizzle_viewDidLoad));
    method_exchangeImplementations(original, swizzled);
    
    SEL exchangeSel = @selector(jh_presentViewController:animated:completion:);
    SEL originalSel = @selector(presentViewController:animated:completion:);
    method_exchangeImplementations(class_getInstanceMethod(self.class, originalSel), class_getInstanceMethod(self.class, exchangeSel));
}

-(void) dosSomethingWith{
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor, NSFontAttributeName : [UIFont systemFontOfSize:19]};
}

- (void)jh_presentViewController:(UIViewController *)viewControllerPresent animated:(BOOL)flag completion:(void(^ __nullable)(void))completion{
    viewControllerPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self jh_presentViewController:viewControllerPresent animated:flag completion:completion];
}

@end
