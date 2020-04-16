//
//  CustomerFootIdentificationView.h
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/15.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerFootIdentificationView : UIView
/**
 @prarm pointX 线的X
 @prarm width 线的宽度
 @prarm title 中间的文字
 */
- (void)footViewWithlineWidth:(CGFloat)width lineWithOriginY:(CGFloat)Y titleWithStr:(NSString *)title;
@end
