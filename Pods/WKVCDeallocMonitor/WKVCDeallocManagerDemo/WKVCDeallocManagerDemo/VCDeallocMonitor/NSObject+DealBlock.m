//
//  NSObject+DealBlock.m
//  KanManHua
//
//  Created by Banning on 2017/11/14.
//  Copyright © 2017年 KanManHua. All rights reserved.
//
#import "NSObject+DealBlock.h"
#import "KMDeallocBlockExecutor.h"
#import <objc/runtime.h>

static void *kNSObject_DeallocBlocks;

@implementation NSObject (DealBlock)

- (id)addDealBlock:(void (^)())deallocBlock {
    if (deallocBlock == nil) {
        return nil;
    }
    NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &kNSObject_DeallocBlocks);
    if (deallocBlocks == nil) {
        deallocBlocks = [NSMutableArray array];
        objc_setAssociatedObject(self, &kNSObject_DeallocBlocks, deallocBlocks, OBJC_ASSOCIATION_RETAIN);
    }
    for (KMDeallocBlockExecutor *executor in deallocBlocks) {
        if (executor.deallocBlock == deallocBlock) {
            return nil;
        }
    }
    KMDeallocBlockExecutor *executor = [KMDeallocBlockExecutor executorWithDeallocBlock:deallocBlock];
    [deallocBlocks addObject:executor];
    return executor;
}

@end
