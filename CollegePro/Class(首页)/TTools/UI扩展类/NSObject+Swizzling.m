//
//  NSObject+Swizzling.m
//  DragTableviewCell
//
//  Created by PacteraLF on 16/11/24.
//  Copyright © 2016年 PacteraLF. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char const * kObservers= "DHOBSERVERS";

#define force_inline __inline__ __attribute__((always_inline))

@interface DHObserverInfo : NSObject
@property (nonatomic, copy) NSString *observerName;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) DHObserveValueChanged block;
@end
@implementation DHObserverInfo

- (instancetype)initWithObserver:(NSString *)observerName key:(NSString *)key block:(DHObserveValueChanged)block
{
    self = [super init];
    if (self) {
        _observerName = observerName;
        _key = key;
        _block = block;
    }
    return self;
}
@end


@implementation NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    // 若原来的方法并不存在，则添加即可
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
//+ (void)load
//{
//    [self switchMethod];
//}
//+ (void)switchMethod
//{
//    SEL cyAddSel = @selector(cy_addObserver:forKeyPath:options:context:);
//    SEL sysAddSel = @selector(addObserver:forKeyPath:options:context:);
//
//    Method cyAddMethod = class_getClassMethod([self class],cyAddSel);
//    Method sysAddMethod = class_getClassMethod([self class], sysAddSel);
//
//    method_exchangeImplementations(cyAddMethod, sysAddMethod);
//}
//// 交换后的方法
//- (void)cy_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
//{
//    @try {
//        if ([keyPath isEqualToString:@"can_not_observer_name"]) {
//            return;
//        }
//        [self cy_addObserver:observer forKeyPath:keyPath options:options context:context];
//    } @catch (NSException *exception) {}
//}
//自定义添加KVO监听
- (void)dh_addObserver:(NSObject *)observer forKey:(NSString *)key options:(NSKeyValueObservingOptions)options block:(DHObserveValueChanged)block{
    NSString *setterStr = private_setterForKey(key);
    Method setterMethod = class_getInstanceMethod(self.class, NSSelectorFromString(setterStr));
    NSString *oldClassName = NSStringFromClass(self.class);
    NSString *kvoClassName = [@"DHKVONotifying_" stringByAppendingString:oldClassName];
    Class kvoClass;
    kvoClass = objc_lookUpClass(kvoClassName.UTF8String);
    if (!kvoClass) {
        kvoClass = objc_allocateClassPair(self.class, kvoClassName.UTF8String, 0);
        objc_registerClassPair(kvoClass);
    }
    if (setterMethod) {//直接调用setXX方法改变值
        class_addMethod(kvoClass,NSSelectorFromString(setterStr), (IMP)setterIMP, "v@:@");
    }else{//通过kvc改变值,通过method-swizzling
        Method method1 = class_getInstanceMethod(self.class, @selector(setValue:forKey:));
        Method method2 = class_getInstanceMethod(self.class, @selector(swizz_setValue:forKey:));
        method_exchangeImplementations(method1, method2);
    }
    object_setClass(self, kvoClass);
    DHObserverInfo *info = [[DHObserverInfo alloc] initWithObserver:observer.description key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, kObservers);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, kObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
}
//自定义移除KVO监听
- (void)dh_removeObserver:(NSObject *)observer forKey:(NSString *)key context:(nullable void *)context{
    NSMutableArray* observers = objc_getAssociatedObject(self, kObservers);
    DHObserverInfo *info;
    for (DHObserverInfo* temp in observers) {
        if ([temp.observerName isEqualToString:observer.description] && [temp.key isEqual:key]) {
            info = temp;
            break;
        }
    }
    if (info) {
        [observers removeObject:info];
    }else{
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ does not register observer for %@",observer.description,key] userInfo:nil];
    }
}
-(void)dh_removeObserver:(NSObject *)observer{
    NSMutableArray* observers = objc_getAssociatedObject(self, kObservers);
    NSMutableArray *array = [NSMutableArray array];
    for (DHObserverInfo* temp in observers) {
        if ([temp.observerName isEqualToString:observer.description]) {
            [array addObject:temp];
        }
    }
    if (array.count) {
        [observers removeObjectsInArray:array];
    }
}
#pragma mark swizz
-(void)swizz_setValue:(id)value forKey:(NSString *)key{
    id oldValue = [self valueForKey:key];
    [self swizz_setValue:value forKey:key];//如果这里没报错，说明正常设置值，现在开始回调
    NSMutableArray *observers = objc_getAssociatedObject(self, kObservers);
    for (DHObserverInfo *temp in observers) {
        if ([temp.key isEqualToString:key]) {
            temp.block(self, key, oldValue, value);
        }
    }
}
#pragma mark overrid
void setterIMP(id self,SEL _cmd,id newValue){
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *temp = private_upperTolower([setterName substringFromIndex:@"set".length], 0);//去除set并将大写改成小写
    NSString *key = [temp substringToIndex:temp.length-1];//去除冒号
    id oldValue = [self valueForKey:key];
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&superClazz, _cmd, newValue);
    NSMutableArray *observers = objc_getAssociatedObject(self, kObservers);
    for (DHObserverInfo *temp in observers) {
        if ([temp.key isEqualToString:key]) {
            temp.block(self, key, oldValue, newValue);
        }
    }
}
#pragma mark inline
static force_inline NSString * private_setterForKey(NSString *key){
    key = private_lowerToUpper(key, 0);
    return [NSString stringWithFormat:@"set%@:",key];
}

static force_inline NSString * private_lowerToUpper(NSString *str,NSInteger location){
    NSRange range = NSMakeRange(location, 1);
    NSString *lowerLetter = [str substringWithRange:range];
    return [str stringByReplacingCharactersInRange:range withString:lowerLetter.uppercaseString];
}
static force_inline NSString * private_upperTolower(NSString *str,NSInteger location){
    NSRange range = NSMakeRange(location, 1);
    NSString *lowerLetter = [str substringWithRange:range];
    return [str stringByReplacingCharactersInRange:range withString:lowerLetter.lowercaseString];
}
@end
