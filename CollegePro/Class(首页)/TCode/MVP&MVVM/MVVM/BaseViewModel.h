//
//  BaseViewModel.h
//  002-MVVM
//
//  Created by Cooci on 2018/6/14.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(id data);

@interface BaseViewModel : NSObject{
    @public
    NSString *name;
}

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailBlock failBlock;

- (void)initWithBlock:(SuccessBlock)successBlock fail:(FailBlock)failBlock;
@end
