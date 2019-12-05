//
//  LHSelectWatermarkView.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/10.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMaxWatermarkCount  8 //每次增加的时候 记得给cellStatus加 @NO

@protocol  LHSelectWatermarkViewDelegate<NSObject>

- (void)selectWatermarkWithImageIndex:(NSInteger)index WithState:(BOOL)state;

@end

@interface LHSelectWatermarkView : UIView

@property (nonatomic, weak) id <LHSelectWatermarkViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithWatermarks:(NSArray *)watermarks;

/**
 恢复到默认水印选中状态
 */
- (void)defaultWatermark;

/**
 取消选中状态

 @param index 索引
 */
- (void)reloadCellStatusWithIndex:(NSInteger)index;
@end
