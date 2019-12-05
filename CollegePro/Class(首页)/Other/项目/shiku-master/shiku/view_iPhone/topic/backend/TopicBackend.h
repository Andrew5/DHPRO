//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicAssembler.h"

/**
 *  Api接口
 */

@interface TopicBackend : Backend
@property (strong, nonatomic) TopicAssembler *assembler;
/**
 *  获取
 *
 *  @return <#return value description#>
 */
- (RACSignal *)requestTopicList;
-(RACSignal *)requestTopicItem;
@end
