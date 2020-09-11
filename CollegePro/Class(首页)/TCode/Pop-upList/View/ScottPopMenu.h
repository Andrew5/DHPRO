//
//  ScottPopMenu.h
//  QQLive
//
//  Created by Scott_Mr on 2016/12/5.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ScottPopMenuType) {
    ScottPopMenuTypeDefault = 0,
    ScottPopMenuTypeDark
};


@class ScottPopMenu;
@protocol ScottPopMenuDelegate <NSObject>

- (void)popMenu:(ScottPopMenu *)popMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ScottPopMenu : UIView

@property (nonatomic, weak) id<ScottPopMenuDelegate> delegate;

@property (nonatomic, assign, readonly) CGFloat arrowHeight;
@property (nonatomic, assign, readonly) CGFloat arrowWidth;
@property (nonatomic, assign, readonly) CGFloat buttomHeight;
// Default is 5.0
@property (nonatomic, assign) CGFloat cornerRadius;
// Default is YES ,(选中菜单之后消失)
@property (nonatomic, assign, getter=isDismissOnSelect) BOOL dismissOnSelect;
// Default is YES, (点击菜单外消失)
@property (nonatomic, assign, getter=isDismissOnTapOutside) BOOL dismissOnTapOutside;
// Default is 15 （设置字体大小）
@property (nonatomic, assign) CGFloat textFontSize;
// Default is Black (设置字体颜色)
@property (nonatomic, strong) UIColor *textColor;
// Default is 0（设置偏移距离）
@property (nonatomic, assign) CGFloat offset;
// Default is YES (当有导航栏的时候，注意此处属性)
@property (nonatomic, assign, getter=isTranslucent) BOOL translucent;

// Default is ScottPopMenuTypeDefault (设置类型)
@property (nonatomic, assign) ScottPopMenuType popMenuType;
// 设置阴影
@property (nonatomic, assign, getter=isShowShadow) BOOL showShadow;


/**
 初始化方法

 @param point 在指定位置弹出
 @param titles 标题数据
 @param icons icon数组
 @param menuWidth 组件宽度
 @param delegate 代理
 @return 初始化后的popMenu
 */
+ (instancetype)popMenuAtPoint:(CGPoint)point withTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate;


/**
 依赖指定view弹出

 @param relyView 依赖的view
 @param titles 标题数组
 @param icons icon数组
 @param menuWidth 组件宽度
 @param delegate 代理
 @return 初始化后的popMenu
 */
+ (instancetype)popMenuRelyOnView:(UIView *)relyView withTitles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)menuWidth delegate:(id<ScottPopMenuDelegate>)delegate;

- (void)dismiss;

NS_ASSUME_NONNULL_END

@end
