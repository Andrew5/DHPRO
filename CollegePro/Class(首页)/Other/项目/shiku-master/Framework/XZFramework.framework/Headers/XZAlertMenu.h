//
//  XZAlertMenu.h
//  XZActionView
//
//  Created by Txj on 14-11-26.
//  Copyright (c) 2014年 Txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZBaseMenu.h"

@interface XZAlertMenu : XZBaseMenu

- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)buttonTitles,...;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
