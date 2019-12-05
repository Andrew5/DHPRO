//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderAssembler.h"
#import "Cart.h"

@protocol OrderDelegate <NSObject>

- (void)sendEorrBack;

@end

@interface OrderBackend : Backend
@property (strong, nonatomic) OrderAssembler *assembler;
@property (nonatomic,weak)id<OrderDelegate> delegate;
/**
 *  请求订单列表
 *
 *  @param anUser 用户信息，废弃，可以不传
 *
 *  @return <#return value description#>
 */
- (RACSignal *)requestOrderListWithUser:(USER *)anUser;
/**
 *  请求订单列表
 *
 *  @param filter 过滤器（已收货，未收货....具体请参见接口api）
 *  @param user   用户信息，废弃
 *
 *  @return
 */
- (RACSignal *)requestOrderListWithUser:(FILTER *)filter withUser:(USER *)user;
/**
 *  订单删除
 *
 *  @param order
 *
 *  @return
 */
- (RACSignal *)requestDeleteOrder:(ORDER *)order;
/**
 *  订单新增
 *
 */
- (RACSignal *)requestAddOrder:(Cart *)cart express_type:(NSString *)express_type quanData:(NSDictionary *)quanData to_area_id:(NSString *)to_area_id;

/**
 *  提交订单
 *
 */
- (RACSignal *)requestConfirmOrder:(ORDER *)order;
/**
 *  关闭订单
 *
 */
- (RACSignal *)requestCloseOrder:(ORDER *)order;

/**
 *  优惠价获取
 *
 *  @param couponCode
 *
 *  @return
 */
- (RACSignal *)requestcouponCode:(NSString *)couponCode  totalPrice:(NSString *)totalPrice items:(NSArray *)Goods_id;
@end
