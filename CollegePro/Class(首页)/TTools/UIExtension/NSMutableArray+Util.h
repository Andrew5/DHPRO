//
//  NSMutableArray+Util.h
//  Test
//
//  Created by Rillakkuma on 2016/12/23.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Util)
#pragma mark - Add
- (void)safeAddObject:(id)obj;
- (void)safeAddObjectsFromArray:(NSArray *)otherArray;
- (id)safeObjectAtIndex:(NSInteger)index;
#pragma mark - Insert
- (void)safeInsertObject:(id)obj atIndex:(NSUInteger)index;
- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;

#pragma mark - Remove
- (void)safeRemoveObject:(id)anObject;
- (void)safeRemoveLastObject;
- (void)safeRemoveObject:(id)anObject inRange:(NSRange)aRange;
- (void)safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)safeRemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange;
- (void)safeRemoveObjectsAtIndexex:(NSIndexSet *)indexes;

#pragma mark - Replace
- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)safeReplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;
@end
