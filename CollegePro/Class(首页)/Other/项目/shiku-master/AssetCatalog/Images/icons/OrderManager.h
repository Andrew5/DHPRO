//
//  OrderManager.h
//  shiku
//
//  Created by  on 15/9/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderManager : NSObject

@property (nonatomic,assign)NSInteger orderNum;//订单数
@property (nonatomic,assign)NSInteger sendNum;//待发送数量
@property (nonatomic,assign)NSInteger recerveNum;//代收货数量
@property (nonatomic,assign)NSInteger refundNum;//退款数量


+ (OrderManager*)shareOrederManager;
+ (void)changeOrderNum;
+ (void)changeSendNum;
+ (void)changeReceiceNum;
+ (void)changeRefundNUm;
+ (void)saveData;
@end
