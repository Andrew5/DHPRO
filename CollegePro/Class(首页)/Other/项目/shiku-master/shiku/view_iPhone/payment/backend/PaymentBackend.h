//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentAssembler.h"
/**
 *支付后台接口
 */
@interface PaymentBackend : Backend
@property (strong, nonatomic) PaymentAssembler *assembler;
/**
 *  结算请求
 *
 *  @param order 订单信息
 *  @param payid 支付类型，支付宝、微信支付，具体参数值参见接口文档
 *
 */
- (RACSignal *)requestCheckout:(ORDER *)order payId:(NSInteger)payid;
@end
