//
//  MonerBackend.h
//  shiku
//
//  Created by yanglele on 15/9/9.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Backend.h"

@interface MoneyBackend : Backend

@property(nonatomic, strong)BackendAssembler * assembler;

-(instancetype)init;

-(RACSignal *)GetTheBalance;

-(RACSignal *)GetWithdrawalUserName:(NSString *)UserName money:(NSString *)money card_no:(NSString *)card_no type:(NSString *)type;
@end
