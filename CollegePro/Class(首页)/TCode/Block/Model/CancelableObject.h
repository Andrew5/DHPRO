//
//  CancelableObject.h
//  CollegePro
//
//  Created by jabraknight on 2020/3/23.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^CancelableBlock)(void);
typedef void (^Block)(void);
@interface CancelableObject : NSObject
- (id)initWithBlock:(Block)block;
- (void)start;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
