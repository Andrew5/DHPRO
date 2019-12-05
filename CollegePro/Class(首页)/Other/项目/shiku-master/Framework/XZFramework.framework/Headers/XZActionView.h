//
//  XZActionMenu.h
//  XZActionView
//
//  Created by Txj on 14-11-26.
//  Copyright (c) 2014年 Txj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, XZActionViewStyle){
    XZActionViewStyleLight = 0,     // 浅色背景，深色字体
    XZActionViewStyleDark           // 深色背景，浅色字体
};

typedef void(^XZMenuActionHandler)(NSInteger index);

@interface XZActionView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) XZActionViewStyle style;

/**
 *  获取单例
 */
+ (XZActionView *)sharedActionView;

/**
 *	提示框弹出层（单按钮）
 *
 *	@param 	title       标题
 *	@param 	message 	提示内容
 *	@param 	buttonTitle 按钮标题
 *	@param 	handler 	点击按钮时回调
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle
            selectedHandle:(XZMenuActionHandler)handler;

/**
 *	提示框弹出层（双按钮）
 *
 *	@param 	title       标题
 *	@param 	message 	提示内容
 *	@param 	leftTitle 	左按钮标题
 *	@param 	rightTitle 	右按钮标题
 *	@param 	handler 	回调， 0 为左， 1 为右
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftButtonTitle:(NSString *)leftTitle
          rightButtonTitle:(NSString *)rightTitle
            selectedHandle:(XZMenuActionHandler)handler;


/**
 *	选择列表弹出层
 *
 *	@param 	title           标题
 *	@param 	itemTitles      行标题
 *	@param 	itemSubTitles 	行子标题
 *	@param 	handler         回调，index从 0 开始
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
             selectedIndex:(NSInteger)selectedIndex
            selectedHandle:(XZMenuActionHandler)handler;


/**
 *	选择列表弹出层（指定选中行）
 *
 *	@param 	title           标题
 *	@param 	itemTitles      行标题
 *	@param 	itemSubTitles 	行子标题
 *	@param 	selectedIndex 	选中行index
 *	@param 	handler         回调，index从 0 开始
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
             itemSubTitles:(NSArray *)itemSubTitles
             selectedIndex:(NSInteger)selectedIndex
            selectedHandle:(XZMenuActionHandler)handler;


/**
 *	服务网格弹出层
 *
 *	@param 	title       标题
 *	@param 	itemTitles 	元素标题
 *	@param 	images      元素图标
 *	@param 	handler 	回调，元素index从 1 开始，0 为取消。
 */
+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
               selectedHandle:(XZMenuActionHandler)handler;


@end
