//
//  HomeNewBackend.h
//  shiku
//
//  Created by  on 15/9/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Backend.h"
#import "HomeNewAssembler.h"

@protocol HomeNewDelegate <NSObject>

- (void)sendDataBack:(GOODS*)anGood;

@end

@interface HomeNewBackend : Backend
@property (strong, nonatomic) HomeNewAssembler *assembler;

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
@property (nonatomic,weak)id<HomeNewDelegate>delegate;
-(void)requestGoodsWithId:(NSNumber *)goods_id;
@end
