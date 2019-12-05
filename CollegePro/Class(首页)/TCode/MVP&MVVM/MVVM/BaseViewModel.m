//
//  BaseViewModel.m
//  002-MVVM
//
//  Created by Cooci on 2018/6/14.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)initWithBlock:(SuccessBlock)successBlock fail:(FailBlock)failBlock{
    _successBlock = successBlock;
    _failBlock    = failBlock;
}
@end
