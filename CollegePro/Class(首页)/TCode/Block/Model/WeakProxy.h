//
//  WeakProxy.h
//  CollegePro
//
//  Created by jabraknight on 2020/3/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakProxy : NSProxy
@property (nonatomic, weak, readonly) id weakTarget;

+ (instancetype)proxyWithTarget:(id)target;
- (instancetype)initWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
