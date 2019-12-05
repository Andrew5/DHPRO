//
//  CooperativeBackend.h
//  shiku
//
//  Created by yanglele on 15/8/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Backend.h"
#import "BackendAssembler.h"
@interface CooperativeBackend : Backend

@property(nonatomic, strong)BackendAssembler * assembler;
-(RACSignal *)RequestCooperativeMemberIdentity:(NSString *)UserID;

-(RACSignal *)RequestCooperativegetCouponCode;
@end
