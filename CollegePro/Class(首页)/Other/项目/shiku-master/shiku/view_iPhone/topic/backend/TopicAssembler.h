//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Json数据解析器
 */
@interface TopicAssembler : BackendAssembler

-(NSArray *)cateListWithJSON:(NSArray *)JSON;
-(CATEGORY *)cateWithJSON:(NSDictionary *)JSON;
@end
