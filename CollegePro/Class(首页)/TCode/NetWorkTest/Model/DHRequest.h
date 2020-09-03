//
//  DHRequest.h
//  CollegePro
//
//  Created by admin on 2020/8/28.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "YTKRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface DHRequest : YTKRequest
- (id)initWithUsername:(NSString *)username password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
