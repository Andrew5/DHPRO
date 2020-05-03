//
//  NSArray+CrashCustom.m
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "NSArray+CrashCustom.h"

@implementation NSArray (CrashCustom)
+ (void)load{
    [super load];
    //替换不可变数组方法
    Method oldObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method newObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtSafeIndex:));
    method_exchangeImplementations(oldObjectAtIndex, newObjectAtIndex);
    //替换可变数组方法
    Method oldMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method newMutableObjectAtIndex =  class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(mutableObjectAtSafeIndex:));
    method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
}
 
- (id)objectAtSafeIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self objectAtSafeIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception.reason);
            return nil;
        }
    }else {
        return [self objectAtSafeIndex:index];
    }
}

- (id)mutableObjectAtSafeIndex:(NSUInteger)index{
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self mutableObjectAtSafeIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception.reason);
            return nil;
        }
    }else {
        return [self mutableObjectAtSafeIndex:index];
    }
}

@end
