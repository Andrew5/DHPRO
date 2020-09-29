//
//  PromiseRequest.h
//  ichangtou
//
//  Created by ONE on 2020/7/7.
//  Copyright © 2020 ichangtou. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import <PromiseKit/PromiseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromiseRequest : YTKRequest


/// 发起请求
- (AnyPromise *)launch;


/// code非2000当作失败，返回code码和message
- (AnyPromise *)statusLaunch;


@end

NS_ASSUME_NONNULL_END
