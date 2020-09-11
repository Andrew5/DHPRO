//
//  SubOperation.h
//  TableViewAnimationKit-OC
//
//  Created by jabraknight on 2020/4/6.
//  Copyright © 2020 com.cn.fql. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
  typedef enum {
    AFOperationPausedState      = -1,
    AFOperationReadyState       = 1,
    AFOperationExecutingState   = 2,
    AFOperationFinishedState    = 3,
} _AFOperationState;
typedef signed short AFOperationState;

@interface SubOperation : NSOperation
@property(nonatomic ,assign )AFOperationState  state ;

@end

NS_ASSUME_NONNULL_END
