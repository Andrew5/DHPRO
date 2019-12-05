//
//  HomeGetdata.h
//  shiku
//
//  Created by Rilakkuma on 15/8/1.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  分类对象
 */
@interface HomeGetdata : NSObject

/**
 * banner图片
 */
@property (nonatomic, retain) NSDictionary * covers;
/**
 * items图片
 */
@property (nonatomic, retain) NSMutableArray * items;
/**
 * 商品分类
 */
@property (nonatomic, copy) NSMutableArray * items_cate;
/**
 * 商品图片
 */
@property (nonatomic, copy) NSMutableArray * goodsImage;
/**
 * 评论量
 */
@property (nonatomic, copy) NSString * shop_rates;
/**
 * 电话号码
 */
@property (nonatomic, copy) NSString * tele;

/**
 * 地图
 */
@property (nonatomic, copy) NSString * mapImage;
/**
 * 关注
 */
@property (nonatomic, copy) NSString * favs;
/**
 * 评语标题
 */
@property (nonatomic, copy) NSString * content;
/**
 * 地址
 */
@property (nonatomic, copy) NSString * address;
/**
 * 90人已认购
 */
@property (nonatomic, copy) NSString * favss;
/**
 * 价钱
 */
@property (nonatomic, copy) NSString * price;
/**
 * 农场介绍
 */
@property (nonatomic, copy) NSString * introduce;

/**
 * 
 */
@property (nonatomic, strong) NSMutableArray * IDArray;
/**
 * 热销
 */
@property (nonatomic, copy) NSString * is_hots;
/**
 *
 */
@property (nonatomic, copy) NSString * name;
/**
 * member头像图片
 */
@property (nonatomic, copy) NSString * img;
/**
 * goods头像图片
 */
@property (nonatomic, copy) NSString * imgStr;
/**
 * cover头像图片
 */
@property (nonatomic, copy) NSString * coverImg;
/**
 * 商品图片
 */
@property (nonatomic, copy) NSString * goodsImg;
/**
 * 销量
 */
@property (nonatomic, copy) NSString * sales;
/**
 * 名称
 */
@property (nonatomic, copy) NSString * title;
/**
 * 名称名称
 */
@property (nonatomic, copy) NSString * titles;
@end

@interface MyfarNSObject : NSObject
@property (strong,nonatomic)NSMutableArray *listArray;
/**
 * 标题
 */
@property (nonatomic, copy) NSString * title;
/**
 * 有机肥含量
 */
@property (nonatomic, copy) NSString * organicStr;

@property (nonatomic, copy) NSString * coverImage;

@property (nonatomic, copy) NSString * midStr;
@end

@interface Recruit : NSObject
/**
 * 购买商品价钱
 */
@property (nonatomic, copy) NSString * prices;
/**
 * 添加时间
 */
@property (nonatomic, copy) NSString * add_time;
/**
 * 状态
 */
@property (nonatomic, copy) NSString *status;
/**
 * 贡献值
 */
@property (nonatomic, copy) NSString * discount_amount;
/**
 * 图像
 */
@property (nonatomic, copy) NSString * img;
@end