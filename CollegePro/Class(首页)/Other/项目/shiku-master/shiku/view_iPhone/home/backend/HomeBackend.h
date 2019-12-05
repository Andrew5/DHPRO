//
//  OrderBackend.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeAssembler.h"

@interface HomeBackend : Backend
@property (strong, nonatomic) HomeAssembler *assembler;
- (RACSignal *)requestHomeItems;
@end
