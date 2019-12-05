//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsAssembler.h"
#import <XZFramework/AdItem.h>

@interface HomeAssembler : BackendAssembler
@property (strong,nonatomic) GoodsAssembler *goodsAssembler;
-(HomeItems *)homeItem:(NSDictionary *)JSON;
@end
