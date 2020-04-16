//
//  SafeSetObject.m
//  MyFirstOCUseSwiftDemo
//
//  Created by jabraknight on 2019/8/12.
//  Copyright © 2019 jabraknight. All rights reserved.
//

#import "SafeSetObject.h"
#import <objc/runtime.h>

#if __has_feature(objc_arc)
//#error "Should disable arc (-fno-objc-arc)"
#endif

static BOOL logEnabled = NO;

#define CDHLOG(...) safeCollectionLog(__VA_ARGS__)

void safeCollectionLog(NSString *fmt, ...) NS_FORMAT_FUNCTION(1, 2);
void safeCollectionLog(NSString *fmt, ...)
{
    if (!logEnabled)
    {
        return;
    }
    va_list ap;
    va_start(ap, fmt);
    NSString *content = [[NSString alloc] initWithFormat:fmt arguments:ap];
    NSLog(@"%@", content);
    va_end(ap);
    
    NSLog(@" ============= call stack ========== \n%@", [NSThread callStackSymbols]);
}
@interface NSArray (DHSafe)

@end
@implementation NSArray (DHSafe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"),selector);
}

- (id)dh_objectAtIndexI:(NSUInteger)index
{
    if (index >= self.count)
    {
        CDHLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self dh_objectAtIndexI:index];
}

+ (id)dh_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id validObjects[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objects[i])
        {
            validObjects[count] = objects[i];
            count++;
        }
        else
        {
            CDHLOG(@"[%@ %@] NIL object at index {%lu}",
                    NSStringFromClass([self class]),
                    NSStringFromSelector(_cmd),
                    (unsigned long)i);
            
        }
    }
    
    return [self dh_arrayWithObjects:validObjects count:count];
}

@end
@interface NSMutableArray (DHSafe)

@end
@implementation NSMutableArray (DHSafe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"),selector);
}

- (id)dh_objectAtIndexM:(NSUInteger)index
{
    if (index >= self.count)
    {
        CDHLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu]",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return nil;
    }
    
    return [self dh_objectAtIndexM:index];
}

- (void)dh_addObject:(id)anObject
{
    if (!anObject)
    {
        CDHLOG(@"[%@ %@], NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    [self dh_addObject:anObject];
}

- (void)dh_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count)
    {
        CDHLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject)
    {
        CDHLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self dh_replaceObjectAtIndex:index withObject:anObject];
}

- (void)dh_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (index > self.count)
    {
        CDHLOG(@"[%@ %@] index {%lu} beyond bounds [0...%lu].",
                NSStringFromClass([self class]),
                NSStringFromSelector(_cmd),
                (unsigned long)index,
                MAX((unsigned long)self.count - 1, 0));
        return;
    }
    
    if (!anObject)
    {
        CDHLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self dh_insertObject:anObject atIndex:index];
}

@end
@interface NSDictionary (DHSafe)

@end

@implementation NSDictionary (DHSafe)

+ (instancetype)dh_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objects[i] && keys[i])
        {
            validObjects[count] = objects[i];
            validKeys[count] = keys[i];
            count ++;
        }
        else
        {
            CDHLOG(@"[%@ %@] NIL object or key at index{%lu}.",
                    NSStringFromClass(self),
                    NSStringFromSelector(_cmd),
                    (unsigned long)i);
        }
    }
    
    return [self dh_dictionaryWithObjects:validObjects forKeys:validKeys count:count];
}

@end
@interface NSMutableDictionary (DHSafe)

@end

@implementation NSMutableDictionary (DHSafe)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"),selector);
}

- (void)dh_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!aKey)
    {
        CDHLOG(@"[%@ %@] NIL key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    if (!anObject)
    {
        CDHLOG(@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        return;
    }
    
    [self dh_setObject:anObject forKey:aKey];
}

@end

#pragma mark - Mama

@implementation SafeSetObject

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // NSArray
        [self exchangeOriginalMethod:[NSArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSArray methodOfSelector:@selector(dh_objectAtIndexI:)]];
        [self exchangeOriginalMethod:class_getClassMethod([NSArray class], @selector(arrayWithObjects:count:))
                       withNewMethod:class_getClassMethod([NSArray class], @selector(dh_arrayWithObjects:count:))];
        // NSMutableArray
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(objectAtIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(dh_objectAtIndexM:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(replaceObjectAtIndex:withObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(dh_replaceObjectAtIndex:withObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(addObject:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(dh_addObject:)]];
        [self exchangeOriginalMethod:[NSMutableArray methodOfSelector:@selector(insertObject:atIndex:)] withNewMethod:[NSMutableArray methodOfSelector:@selector(dh_insertObject:atIndex:)]];
        // NSDictionary
        [self exchangeOriginalMethod:class_getClassMethod([NSDictionary class], @selector(dictionaryWithObjects:forKeys:count:))
                       withNewMethod:class_getClassMethod([NSDictionary class], @selector(dh_dictionaryWithObjects:forKeys:count:))];
        // NSMutableDictionary
        [self exchangeOriginalMethod:[NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)] withNewMethod:[NSMutableDictionary methodOfSelector:@selector(dh_setObject:forKey:)]];
    });
}

+ (void)exchangeOriginalMethod:(Method)originalMethod withNewMethod:(Method)newMethod
{
    method_exchangeImplementations(originalMethod, newMethod);
}

+ (void)setLogEnabled:(BOOL)enabled
{
    logEnabled = enabled;
}

@end

