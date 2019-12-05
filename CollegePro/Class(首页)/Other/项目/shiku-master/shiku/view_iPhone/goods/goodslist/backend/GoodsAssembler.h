//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  商品解析器
 */
@interface GoodsAssembler : BackendAssembler
/**
 *  商品列表解析
 */
-(NSArray *)goodsListWithJSON:(NSArray *)JSON;
/**
 *  单个商品解析
 *
 */
-(GOODS *)goodsWithJSON:(NSDictionary *)JSON;

-(GOODS_DETAIL_INFO *)goodsDetailsWithJSON:(NSDictionary *)JSON;
-(CATEGORY *)goodDetailWithJSON:(NSDictionary *)JSON;
@end
