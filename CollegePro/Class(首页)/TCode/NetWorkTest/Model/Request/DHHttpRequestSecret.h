//
//  DHHttpRequestSecret.h
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHHttpRequestSecret : YTKRequest
@property (nonatomic, assign) BOOL needToken;

@end

NS_ASSUME_NONNULL_END
