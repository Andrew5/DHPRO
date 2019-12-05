//
//  UITabBar+XSDExt.h
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (XSDExt)
- (void)showBadgeOnItemIndex:(NSInteger)index numberWithInt:(NSString *)tag;   ///<显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index;  ///<隐藏小红点  
@end
