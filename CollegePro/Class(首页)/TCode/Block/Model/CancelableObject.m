//
//  CancelableObject.m
//  CollegePro
//
//  Created by jabraknight on 2020/3/23.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "CancelableObject.h"
@interface CancelableObject()
{
    BOOL _isCanceled;
    Block _block;
}
@end
@implementation CancelableObject
/**
 将要执行的 block 直接放到执行队列中，但是让其在执行前检查另一个 isCanceled 的变量，然后把这个变量的修改实现在另一个 block 方法中
 */
+ (CancelableBlock)dispatch_async_with_cancelable:(Block)block {

    __block BOOL isCanceled = NO;
    CancelableBlock cb = ^() {
        isCanceled = YES;
    };

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!isCanceled) {
            block();
        }
    });

    return cb;
}
//创建一个类，将要执行的 block 封装起来，然后类的内部有一个 _isCanceled 变量，在执行的时候，检查这个变量，如果 _isCanceled 被设置成 YES 了，则退出执行
- (id)initWithBlock:(Block)block {
    self = [super init];
    if (self != nil) {
        _isCanceled = NO;
        _block = block;
    }
    return self;
}

- (void)start {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
       ^{
        if (weakSelf) {
           typeof(self) strongSelf = weakSelf;
           if (!strongSelf->_isCanceled) {
               (strongSelf->_block)();
           }
        }
    });
}

- (void)cancel {
    _isCanceled = YES;
}
@end
