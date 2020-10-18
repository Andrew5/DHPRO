//
//  DHObserverManager.h
//  CollegePro
//
//  Created by jabraknight on 2020/10/18.
//  Copyright © 2020 jabrknight. All rights reserved.
//
//  学习
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHObserverManager : NSObject
// 初始化的时候 需要一个协议和一组观察者
- (id)initWithProtocol:(Protocol *)protocol observers:(NSSet *)observers;
// 添加观察者
- (void)addObserver:(id)observer;
// 删除观察者
- (void)removeObserver:(id)observer;
@end

NS_ASSUME_NONNULL_END
