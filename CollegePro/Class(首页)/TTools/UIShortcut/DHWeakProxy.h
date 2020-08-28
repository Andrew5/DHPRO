//
//  DHWeakProxy.h
//  CollegePro
//
//  Created by jabraknight on 2020/7/18.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHWeakProxy : NSProxy
// 对target有一个弱引用
@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
