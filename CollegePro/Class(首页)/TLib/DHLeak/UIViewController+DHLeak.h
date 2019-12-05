//
//  UIViewController+DHLeak.h
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DHLeak)
/**
 标记是否是从控制器栈中移除，准备释放
 */
@property (nonatomic, assign) BOOL isDeallocDisappear;
- (void) willDealloc;
@end

NS_ASSUME_NONNULL_END
