//
//  BaseViewController.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/20.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// 设置标题
- (void)addTitleViewWithTitle:(NSString *)title;
// 设置左右按钮
- (void)addBarButtonItem:(NSString *)name image:(UIImage *) image target:(id)target action:(SEL)action isLeft:(BOOL)isLeft;
@end
