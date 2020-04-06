//
//  UIView+ActivityIndicator.h
//  GHAlibabaSpecificationSelectionDemo
//
//  Created by mac on 2019/11/28.
//  Copyright © 2019 macBookPro. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ActivityIndicator)

- (void)addActivityIndicator;

- (void)gh_startAnimating;

- (void)gh_stopAnimating;

@end

NS_ASSUME_NONNULL_END
