//
//  LJInstrumentView.h
//  节能宝
//
//  Created by 卢杰 on 16/8/16.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"
@interface LJInstrumentView : UIView
/**
 *  速度值
 */
@property (nonatomic, strong) UICountingLabel *speedLabel;
/**
 *  设定速度值
 */
@property (nonatomic,assign)NSUInteger speedValue;
/**
 *  时间间隔
 */
@property (nonatomic,assign)CGFloat timeInterval;
/**
 *  画弧度
 *
 *  @param startAngle  开始角度
 *  @param endAngle    结束角度
 *  @param lineWitdth  线宽
 *  @param filleColor  扇形填充颜色
 *  @param strokeColor 弧线颜色
 */
-(void)drawArcWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle lineWidth:(CGFloat)lineWitdth fillColor:(UIColor*)filleColor strokeColor:(UIColor*)strokeColor;

/**
 *  画刻度
 *
 *  @param divide      刻度几等分
 *  @param remainder   刻度数
 *  @param strokeColor 轮廓填充颜色
 *  @param fillColor   刻度颜色
 */
//center:中心店，即圆心
//startAngle：起始角度
//endAngle：结束角度
//clockwise：是否逆时针
-(void)drawScaleWithDivide:(int)divide andRemainder:(NSInteger)remainder strokeColor:(UIColor*)strokeColor filleColor:(UIColor*)fillColor scaleLineNormalWidth:(CGFloat)scaleLineNormalWidth scaleLineBigWidth:(CGFloat)scaleLineBigWidth;
/**
 *  画刻度值，逆时针设定label的值，将整个仪表切分为N份，每次递增仪表盘弧度的N分之1
 *
 *  @param divide 刻度值几等分
 */
-(void)DrawScaleValueWithDivide:(NSInteger)divide;
/**
 *  进度条曲线
 *
 *  @param fillColor   填充颜色
 *  @param strokeColor 轮廓颜色
 */
- (void)drawProgressCicrleWithfillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor;
/**
 *  添加渐变图层
 *
 *  @param colorGradArray 颜色数组，如果想达到红-黄-红效果，数组应该是红，黄，红
 */
-(void)setColorGrad:(NSArray*)colorGradArray;
/**
 *  启动进度条
 */
- (void)runSpeedProgress;
@end
