//
//  CodeView.h
//  BaseProject
//
//  Created by my on 16/3/24.
//  Copyright © 2016年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CodeViewType) {
    CodeViewTypeCustom,//普通样式
    CodeViewTypeSecret//密码风格
};

@interface CodeView : UIView

//输入完成回调
@property (nonatomic, copy) void(^EndEditBlcok)(NSString *text);

//样式
@property (nonatomic, assign) CodeViewType codeType;

//是否需要分隔符
@property (nonatomic, assign) BOOL hasSpaceLine;
//是否有下标线
@property (nonatomic, assign) BOOL hasUnderLine;

//是否需要输入之后清空，再次输入使用,默认为NO
@property (nonatomic, assign) BOOL emptyEditEnd;

//是否添加下划线的动画,默认NO
@property (nonatomic, assign) BOOL underLineAnimation;


//在underLineAnimation为YES时，未输入状态下是否闪烁，YES为闪烁 NO不闪烁
@property (nonatomic, assign) BOOL noInputAni;;


//下划线中心点
@property (nonatomic, assign) CGFloat underLine_center_y;


- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                     textFont:(CGFloat)font;

- (void)beginEdit;
- (void)endEdit;

@end
