//
//  UIView+EmptyPage.h
//  GHEmptyPage
//
//  Created by mac on 2019/11/29.
//  Copyright © 2019 Yeetied. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EmptyPageDidClickReloadBlock)(void);

@interface UIView (EmptyPage)

- (void)hideEmptyPage ;

- (void)showEmptyPage:(CGFloat)y imageName:(NSString *)imageName imageFrame:(CGRect)imageFrame didClickReloadBlock:(EmptyPageDidClickReloadBlock)didClickReloadBlock;

@end

NS_ASSUME_NONNULL_END
