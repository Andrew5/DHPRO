//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CateAssembler.h"

@interface CateBackend : Backend
@property (strong, nonatomic) CateAssembler *assembler;
- (RACSignal *)requestCateList;
@end
