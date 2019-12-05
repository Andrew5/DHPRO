//
//  XZSheetMenu.h
//  XZActionView
//
//  Created by Txj on 14-11-26.
//  Copyright (c) 2014年 Txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZBaseMenu.h"

@interface XZSheetMenu : XZBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles;

@property (nonatomic, assign) NSUInteger selectedItemIndex;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
