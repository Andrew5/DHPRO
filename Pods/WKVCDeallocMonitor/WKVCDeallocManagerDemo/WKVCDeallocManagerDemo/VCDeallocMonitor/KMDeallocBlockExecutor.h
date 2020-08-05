//
//  KMDeallocBlockExecutor.h
//  KanManHua
//
//  Created by Banning on 2017/11/14.
//  Copyright © 2017年 KanManHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMDeallocBlockExecutor : NSObject

+ (instancetype)executorWithDeallocBlock:(void (^)())deallocBlock;

@property (nonatomic, copy) void (^deallocBlock)();

@end
