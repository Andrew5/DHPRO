//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsAssembler.h"

@interface GoodsBackend : Backend
@property (strong, nonatomic) GoodsAssembler *assembler;
/**
 *  请求商品详情
 *
 *  @param goods_id 商品记录id
 *
 */
-(RACSignal *)requestGoodsDetailsWithId:(NSNumber *)goods_id;
/**
 *  请求商品简介
 *
 *  @param goods_id 商品记录id
 *
 *  @return
 */
-(RACSignal *)requestGoodsWithId:(NSNumber *)goods_id;
/**
 *  请求商品列表
 *
 *  @param filter 过滤条件
 *
 *  @return 
 */
- (RACSignal *)requestGoodsListWithFilter:(FILTER *)filter;
//- (RACSignal *)requestAddFavItem:(GOODS *)goods;
//-(RACSignal *)requestRemoveFavItems:(NSMutableArray *)items;

//- (RACSignal *)requestAddShopFavItem:(GOODS *)goods;
//-(RACSignal *)requestRemoveShopFavItems:(NSMutableArray *)items;
@end
