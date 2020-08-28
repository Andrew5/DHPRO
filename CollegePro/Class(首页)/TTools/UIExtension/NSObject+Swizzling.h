//
//  NSObject+Swizzling.h
//  DragTableviewCell
//
//  Created by PacteraLF on 16/11/24.
//  Copyright © 2016年 PacteraLF. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^DHObserveValueChanged)(id observedObject, NSString *key, id oldValue, id newValue);

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;
//自定义添加KVO监听
- (void)dh_addObserver:(NSObject *)observer forKey:(NSString *)key options:(NSKeyValueObservingOptions)options block:(DHObserveValueChanged)block;
//自定义移除KVO监听
- (void)dh_removeObserver:(NSObject *)observer forKey:(NSString *)key context:(nullable void *)context;
-(void)dh_removeObserver:(NSObject *)observer;

@end
NS_ASSUME_NONNULL_END
