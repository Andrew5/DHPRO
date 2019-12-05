//
//  UIView+SnapImage.h
//  WKVCDeallocManagerDemo
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WKSnapImage)

- (UIImage *)wk_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

@end
