//
//  UIViewController+DHLeak.m
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "UIViewController+DHLeak.h"
#import "UIViewController+RTCSampleAlert.h"
#import "SwizzManager.h"
const char* deallocKey = "isDeallocDisAppear";
@implementation UIViewController (DHLeak)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSel = @selector(viewDidDisappear:);
        SEL newSel = @selector(dh_viewDidDisappear:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel newSel:newSel];
        SEL originSel1 = @selector(dismissViewControllerAnimated:completion:);
        SEL newSel1 = @selector(dh_dismissViewControllerAnimated:completion:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel1 newSel:newSel1];
        SEL originSel2 = @selector(viewWillAppear:);
        SEL newSel2 = @selector(dh_viewWillAppear:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel2 newSel:newSel2];
    });
}
//进入界面，初始化标志
-(void)dh_viewWillAppear:(BOOL)animated{
    [self dh_viewWillAppear:animated];
    self.isDeallocDisappear = NO;
}
//dismiss时机扑捉并设置标志
-(void)dh_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self dh_dismissViewControllerAnimated:flag completion:completion];
    self.isDeallocDisappear = YES;
}
//即将释放时调用延时任务
- (void)dh_viewDidDisappear:(BOOL)animated{
    [self dh_viewDidDisappear:animated];
    BOOL isDeallocDis = self.isDeallocDisappear;
    if (isDeallocDis) {
        [self willDealloc];
    }
}
//延时处理，如果释放，不会走 [strongSelf showMsg:msg];
- (void) willDealloc{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
//            NSString* msg = [NSString stringWithFormat:@"%@__存在内存泄漏",[weakSelf class]];
//            [strongSelf showMsg:msg];
        }
    });
}
///动态设置isDeallocDisappear标志属性
-(void)setIsDeallocDisappear:(BOOL)isDeallocDisappear{
    objc_setAssociatedObject(self, &deallocKey, @(isDeallocDisappear), OBJC_ASSOCIATION_RETAIN);
}
///动态获取isDeallocDisappear标志属性的值
-(BOOL)isDeallocDisappear{
    
    return ((NSNumber*)objc_getAssociatedObject(self, &deallocKey)).boolValue;
}
///泄漏提示
- (void)showMsg:(NSString *)msg{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DHLeaks"
//                                                            message:msg
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles: nil];
//    [alertView show];
    
//    [MBProgressHUD showInfoMessage:msg];
//    [MBProgressHUD showWarnMessage:msg];

}

@end
