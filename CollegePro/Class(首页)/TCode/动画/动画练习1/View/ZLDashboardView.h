//
//  ZLDashboardView.h
//  Test
//
//  Created by Rillakkuma on 2016/12/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLDashboardView : UIView
@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, copy) void(^TimerBlock)(NSInteger);

/**
 *  跃动数字刷新
 *
 */
- (void)refreshJumpNOFromNO:(NSString *)startNO toNO:(NSString *)toNO;

@end
