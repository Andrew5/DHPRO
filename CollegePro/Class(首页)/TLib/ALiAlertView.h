//
//  ALiAlertView.h
//  ALiAlertView
//
//  Created by LeeWong on 2016/11/4.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiAlertView : UIView
/**
 是否允许根据重力感应调整弹窗的方向
 */
@property (nonatomic, assign) BOOL roattionEnable;


/**
 是否允许点击弹窗之外的区域让弹窗消失
 */
@property (nonatomic, assign) BOOL tapDismissEnable;


/**
 顶部显示的view 外部可以自定义,如果未设置默认使用纯文本的样式
 */
@property (nonatomic, strong) UIView *contentView;


/**
 设置弹窗的方向
 注意这个属性不可以和roattionEnable同时使用，如果同时设置默认使用重力感应
 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

//-------------------------Method-------------------------------------


/**
 初始化方法

 @param aTitle 纯文本样式的标题
 @return 返回配置好的对象
 */
- (instancetype)initWithTitle:(NSString *)aTitle;


/**
 添加按钮的标题以及对应的相应方法

 @param title 标题
 @param clickHandler 点击时相应的方法
 */
- (void)addButtonWithTitle:(NSString *)title whenClick:(void (^)(NSInteger index))clickHandler;

/**
 显示AlertView
 */
- (void)show;


/**
 隐藏AlertView
 */
- (void)dismiss;

@end
