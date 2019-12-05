//
//  GZBaseViewController.h
//  3DTouch(GZ)
//
//  Created by xinshijie on 2017/4/10.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GZBaseViewController;

@protocol GZBaseViewControllerDelegate <NSObject>

@required
// 删除按钮点击
- (void)GZViewController:(GZBaseViewController *)GZVC DidSelectedDeleteItem:(NSString *)navTitle;
// 返回按钮点击
- (void)GZViewControllerDidSelectedBackItem:(GZBaseViewController *)GZVC;

@end


@interface GZBaseViewController : BaseViewController


@property (nonatomic,copy)NSString *navTitle;

@property (nonatomic,weak)id<GZBaseViewControllerDelegate> delegate;


@end
