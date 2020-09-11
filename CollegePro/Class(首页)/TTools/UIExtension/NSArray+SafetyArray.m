//
//  NSArray+SafetyArray.m
//  SafetyObjectDemo
//
//  Created by Artron_LQQ on 16/2/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "NSArray+SafetyArray.h"
#include "NSObject+Until.h"

static const NSString *lqq_defaultObject = @"defaultObject";

@implementation NSArray (SafetyArray)
#pragma mark - 第一种方式:使用runTime替换系统方法,防止数组越界或空值引起的crash
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(lqq_objectAtIndex:) error:nil];
        };
    });
}

- (id)lqq_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self lqq_objectAtIndex:index];
    }
    
    return nil;//越界返回为nil
}

#pragma mark -- 第二种方式:自定义方法,防止数组越界及空值引起的crash
- (id)lqqNew_objectAtIndex:(NSUInteger)index{
    //    [super objectAtIndex:index];
    if (index < self.count)
    {
        return self[index];
    }
    else
    {
        return nil;
    }
}

@end


@implementation NSMutableArray (SafetyArray)

#pragma mark - 第一种方式:使用runTime替换系统方法,防止数组越界或空值引起的crash
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleMethod:
             @selector(objectAtIndex:) withMethod:@selector(lqq_objectAtIndex:) error:nil];
            [objc_getClass("__NSArrayM") swizzleMethod:
             @selector(addObject:) withMethod:@selector(lqq_addObject:) error:nil];
        };
    });
}
-(void)lqq_addObject:(id)object {
    if (!object || [object isKindOfClass:[NSNull class]]) {
        [self lqq_addObject:lqq_defaultObject];
    } else {
        [self lqq_addObject:object];
    }
}
- (id)lqq_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        
        return [self lqq_objectAtIndex:index];
    }
    return nil;//越界返回为nil
}

#pragma mark -- 第二种方式:自定义方法,防止数组越界及空值引起的crash
- (id)lqqNew_objectAtIndex:(NSUInteger)index{
    //    [super objectAtIndex:index];
    if (index < self.count)
    {
        return self[index];
    }
    else
    {
        return nil;
    }
}

-(void)lqqNew_addObject:(id)object {
    if (!object || [object isKindOfClass:[NSNull class]]) {
        [self addObject:lqq_defaultObject];
    } else {
        [self addObject:object];
    }
}
@end

