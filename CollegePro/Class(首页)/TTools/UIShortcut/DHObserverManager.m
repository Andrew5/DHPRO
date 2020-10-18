//
//  DHObserverManager.m
//  CollegePro
//
//  Created by jabraknight on 2020/10/18.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHObserverManager.h"
#import <objc/runtime.h>

@interface DHObserverManager ()
@property (nonatomic, strong) NSMutableSet *observers;
@property (nonatomic, strong) Protocol *protocol;

@end
@implementation DHObserverManager

- (id)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers{
    if (self = [super init]) {
        self.protocol = protocol;
        self.observers = [NSMutableSet setWithSet:observers];
    }
    return self;
}


- (void)addObserver:(id)observer{
    if ([observer conformsToProtocol:self.protocol]) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id)observer{
    [self.observers removeObject:observer];
}

// Objective-C 的消息分派器使用这个方法为未知的选择器构造一个 NSInvocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) {
        return result;
    }
    // 查找所需方法
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
    if(desc.name == NULL){
        // 有可能是协议的可选方法
        desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    }
    if(desc.name == NULL){
        // 找不到方法，那么抛出异常
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }

    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}
// 把方法调用转发到响应选择器的观察者
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    for(id responder in self.observers){
        if ([responder respondsToSelector:selector]) {
            [anInvocation setTarget:responder];
            [anInvocation invoke];
        }
    }
}
@end
