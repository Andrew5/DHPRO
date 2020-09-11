//
//  PromiseRequest.h
//  ichangtou
//
//  Created by ONE on 2020/7/7.
//  Copyright © 2020 ichangtou. All rights reserved.
//

#import "YTKNetwork.h"
#import <PromiseKit/PromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromiseRequest : YTKRequest


- (AnyPromise *)launch;


@end

NS_ASSUME_NONNULL_END
