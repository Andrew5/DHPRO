//
//  CustomSliderView.h
//  LeAi
//
//  Created by MACBOOK on 16/3/10.
//  Copyright © 2016年 yajun.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSliderView : UIView


/**
 *  设置拖动条
 *
 *  @param sliderArry 拖动条值数组
 *  @param maxCount   拖动条数目
 */
-(void)setupSlider:(NSMutableArray *)sliderArry sliderCount:(NSInteger)maxCount;

-(NSMutableArray *)getSliderNum;

@end
