//
//  NSMutableArray+Util.m
//  Test
//
//  Created by Rillakkuma on 2016/12/23.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "NSMutableArray+Util.h"

@implementation NSMutableArray (Util)
- (void)safeAddObject:(id)obj
{
	if (obj) {
		[self addObject:obj];
	}
}

- (void)safeAddObjectsFromArray:(NSArray *)otherArray
{
	if (otherArray.count) {
		[self addObjectsFromArray:otherArray];
	}
}

- (id)safeObjectAtIndex:(NSInteger)index{
	if (index > self.count || index<0) {
		return nil;
	}
	return [self objectAtIndex:index];
}
- (void)safeInsertObject:(id)obj atIndex:(NSUInteger)index
{
	if (obj && index <= self.count) {
		[self insertObject:obj atIndex:index];
	}
}

- (void)safeInsertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
	if (objects.count && indexes) {
		[self insertObjects:objects atIndexes:indexes];
	}
}

- (void)safeRemoveObject:(id)anObject
{
	if (anObject && [self containsObject:anObject]) {
		[self removeObject:anObject];
	}
}

- (void)safeRemoveLastObject
{
	if (self.count) {
		[self removeLastObject];
	}
}

- (void)safeRemoveObject:(id)anObject inRange:(NSRange)aRange
{
	if (anObject && aRange.location + aRange.length < self.count) {
		[self removeObject:anObject inRange:aRange];
	}
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index
{
	if (index < self.count) {
		[self removeObjectAtIndex:index];
	}
}

- (void)safeRemoveObjectIdenticalTo:(id)anObject inRange:(NSRange)aRange
{
	if (anObject && aRange.location + aRange.length < self.count) {
		[self removeObjectIdenticalTo:anObject inRange:aRange];
	}
}

- (void)safeRemoveObjectsAtIndexex:(NSIndexSet *)indexes
{
	if (indexes) {
		[self removeObjectsAtIndexes:indexes];
	}
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	if (anObject && index < self.count) {
		[self replaceObjectAtIndex:index withObject:anObject];
	}
}

- (void)safeReplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects
{
	if (objects.count && indexes) {
		[self replaceObjectsAtIndexes:indexes withObjects:objects];
	}
}
@end
