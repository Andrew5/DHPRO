//
//  MapAnnotationMode.h
//  shiku
//
//  Created by yanglele on 15/8/4.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapAnnotationMode : NSObject

@property(nonatomic ,strong)NSString * ImgUrl;

@property(nonatomic ,strong)NSString * ImgID;

@property(nonatomic ,strong)NSString * m_Mid;

@property(nonatomic ,strong)NSString * pos_lat;

@property(nonatomic ,strong)NSString * pos_lng;
/**
 * 产品标题
 */
@property(nonatomic ,strong)NSString * titleStr;
/**
 * 产地
 */
@property(nonatomic ,strong)NSString * areaStr;
/**
 * 主营
 */
@property(nonatomic ,strong)NSString * catenmaeStr;
/**
 * 距离
 */
@property(nonatomic ,strong)NSString * distanceStr;
/**
 * 销量
 */
@property(nonatomic ,strong)NSString * membersaleStr;

@end
