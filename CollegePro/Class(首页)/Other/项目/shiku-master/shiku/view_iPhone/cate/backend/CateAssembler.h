//
//  OrderAssembler.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateAssembler : BackendAssembler
-(NSArray *)cateListWithJSON:(NSArray *)JSON;
-(CATEGORY *)cateWithJSON:(NSDictionary *)JSON;
@end
