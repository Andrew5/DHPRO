//
//  HomeNewAssembler.h
//  shiku
//
//  Created by  on 15/9/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "BackendAssembler.h"

@interface HomeNewAssembler : BackendAssembler

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
