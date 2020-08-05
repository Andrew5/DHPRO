//
//  KMDeallocBlockExecutor.m
//  KanManHua
//
//  Created by Banning on 2017/11/14.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import "KMDeallocBlockExecutor.h"

@implementation KMDeallocBlockExecutor

+ (instancetype)executorWithDeallocBlock:(void (^)(void))deallocBlock {
    KMDeallocBlockExecutor *o = [KMDeallocBlockExecutor new];
    o.deallocBlock = deallocBlock;
    return o;
}

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
        self.deallocBlock = nil;
    }
}
@end
