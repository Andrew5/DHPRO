//
//  LoTest.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/16.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoTest : YTKRequest
@property(nonatomic, strong) NSString *token;
@property(nonatomic, strong) NSString *accessToken;
- (instancetype)initWithToken:(NSString *)token
                  accessToken:(NSString *)accessToken;
@end

NS_ASSUME_NONNULL_END
