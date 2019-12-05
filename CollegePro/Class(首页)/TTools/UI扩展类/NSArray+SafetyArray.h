//
//  NSArray+SafetyArray.h
//  SafetyObjectDemo
//
//  Created by Artron_LQQ on 16/2/27.
//  Copyright © 2016年 Artup. All rights reserved.
//
/**
 *  @author LQQ, 16-02-28 01:02:00
 *
 *  数组的扩展,可防止数组越界及添加的对象为nil引起的crash
 *
 *  由两种实现方式:1.runtime机制;2.自定义方法
 */

#import <Foundation/Foundation.h>

@interface NSArray (SafetyArray)

- (id)lqqNew_objectAtIndex:(NSUInteger)index;
@end

@interface NSMutableArray (SafetyArray)

- (id)lqqNew_objectAtIndex:(NSUInteger)index;
-(void)lqqNew_addObject:(id)object;
@end

