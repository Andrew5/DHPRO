//
//  DHHttpRequestLoginLogin.h
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "DHHttpBaseHeaderFieldDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHHttpRequestLoginLogin : YTKRequest
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL needToken;

- (instancetype)initWithUsername:(NSString *)username
password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
