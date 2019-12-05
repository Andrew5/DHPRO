//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartAssembler.h"
@class Models;
/**
 *  购物车后台
 */
@interface CartBackend : Backend
@property (strong, nonatomic) CartAssembler *assembler;

@property (nonatomic ,strong) FILTER * m_filter;

- (RACSignal *)requestCartListWithUser:(USER *)anUser;
- (RACSignal *)requestAddItemToLikeList:(NSString *)goodName andGoodsId:(NSString *)goodsId andGoodsNum:(NSInteger)goods_num WithUser:(USER *)anUser;//添加到喜欢列表

- (RACSignal *)requestAddItemToCart:(CATEGORY *)item andGoodsId:(NSNumber *)goodsId andGoodsNum:(NSInteger)goods_num WithUser:(USER *)anUser;//添加到购物车

- (RACSignal *)requestCartGoodsNum:(CART_GOODS *)anGoods;
- (RACSignal *)requestRemoveCartItems:(NSMutableArray *)items;

- (RACSignal *)requestGetExpressPrice:(TOTAL*)total;

- (RACSignal *)requestGetLogistics:(NSNumber *)Goods_id;
///order/express_money
- (RACSignal *)requestexpress_money:(NSMutableArray *)Goods_id to_area_id:(NSString *)area_id express_type:(NSString *)express_type;
@end
