//
//  UIView+ActivityIndicator.m
//  GHAlibabaSpecificationSelectionDemo
//
//  Created by mac on 2019/11/28.
//  Copyright © 2019 macBookPro. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
#import <objc/runtime.h>

static NSString *activityIndicatorKey = @"activityIndicatorKey";

@implementation UIView (ActivityIndicator)

- (void)addActivityIndicator {
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    CGPoint point = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [activity setCenter:point];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self addSubview:activity];
    objc_setAssociatedObject(self, &activityIndicatorKey, activity, OBJC_ASSOCIATION_RETAIN);
}

- (void)gh_startAnimating {
    UIActivityIndicatorView *activity = objc_getAssociatedObject(self, & activityIndicatorKey);
    [activity startAnimating];
}

- (void)gh_stopAnimating {
    UIActivityIndicatorView *activity = objc_getAssociatedObject(self, & activityIndicatorKey);
    [activity stopAnimating];
}

@end
