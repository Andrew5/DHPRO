//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  购物车数据解析
 */
@interface CartAssembler : BackendAssembler
-(NSArray *)shopItemsWithJSON:(NSArray *)JSON;
@end
