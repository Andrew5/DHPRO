//
//  NearData.h
//  shiku
//
//  Created by Rilakkuma on 15/8/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearData : NSObject
/**
 * 商品图
 */
@property (copy, nonatomic)  NSString *imageGoods;
/**
 * 商品标题
 */
@property (copy, nonatomic)  NSString *labelGoodsTitle;

/**
 * 距离显示
 */
@property (copy, nonatomic) NSString *labelDistance;


/**
 * 评分数
 */
@property (copy, nonatomic)   NSString *labelMarlNum;


/**
 * 主营标签
 */
@property (copy, nonatomic)   NSString *labelManagetitle;


/**
 * 销量数
 */
@property (copy, nonatomic)  NSString *labelSalesNum;


/**
 * 产地名称
 */
@property (copy, nonatomic)   NSString *labelPlaceTitle;

@end
