//
//  UIButton+ImageTitleSpacing.h
//  LBFinancial
//
//  Created by Rillakkuma on 2017/12/11.
//  Copyright © 2017年 com.zhongkehuabo.LeBangFinancial. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
	MKButtonEdgeInsetsStyleTop, // image在上，label在下
	MKButtonEdgeInsetsStyleLeft, // image在左，label在右
	MKButtonEdgeInsetsStyleBottom, // image在下，label在上
	MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)
@property (nonatomic, strong) NSString *normalTitle;//按钮文字

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
						imageTitleSpace:(CGFloat)space;  
/**
 *  验证码倒计时  时分倒计时  endTime:结束时间 2016-02-02 12:12:12
 */
- (void)verifedCodeButtonWithTitle:(NSString *)title andNewTitle:(NSString *)newTitle bgImageName:(NSString *)imageName newBgImageName:(NSString *)newImageName;

- (void)relaseTimer;
@end
