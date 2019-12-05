//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  支付信息解析
 */
@interface PaymentAssembler : BackendAssembler
- (PAYMENT *)paymentWithJSON:(NSDictionary *)paymentJSON;
@end
