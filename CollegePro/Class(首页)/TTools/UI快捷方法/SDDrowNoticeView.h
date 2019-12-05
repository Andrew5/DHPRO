//
//  SDDrowNoticeView.h
//  SpeedAcquisitionloan
//
//  Created by 李亚静 on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SDDrowNoticeView : UIView

/**
 类方法实例
 
 @param stringArray 信息数据
 @return 实例
 */
+(instancetype)createDrowNoticeView:(NSArray*)stringArray;


/**
 开启向下弹出动画
 */
- (void)animationDrown;
@end
