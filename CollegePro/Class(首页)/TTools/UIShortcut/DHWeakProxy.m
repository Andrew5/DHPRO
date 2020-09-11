//
//  DHWeakProxy.m
//  CollegePro
//
//  Created by jabraknight on 2020/7/18.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHWeakProxy.h"
#import <objc/message.h>
///
///我们在不希望使关联对象引用计数+1 时，往往会使用 objc_association_assign，但是它在释放时并不等同于 weak，它在释放后并不会置 nil，容易导致内存访问问题
@implementation DHWeakProxy
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
//- (void)forwardInvocation:(NSInvocation *)invocation {
//    void *null = NULL;
//    [invocation setReturnValue:&null];
//}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (Class)class {
    return [_target class];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}
- (BOOL)isProxy {
    return YES;
}

- (void)ty_setWeakAssociate:(id)value withKey:(const void * _Nonnull)key {
    if (!key) {
        return;
    }
    objc_setAssociatedObject(self, key, [DHWeakProxy proxyWithTarget:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
