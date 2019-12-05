//
//  UIButton+Delay.h
//  Test001
//
//  Created by StriEver on 16/4/18.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Delay)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSInteger delayInterval;
@property (nonatomic, retain) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isNeedDelay;
@end
