//
//  DHHttpRequest.h
//  CollegePro
//
//  Created by admin on 2020/8/28.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///网络请求
#import "YTKNetwork.h"
#import "YTKBatchRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHHttpRequest : YTKBaseRequest

@property (nonatomic, assign) BOOL needToken;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
