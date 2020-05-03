//
//  BookDataViewModel.h
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactModel.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DHNetworkResponseResultCompletion)(ContactModel *responseResult);
typedef void(^DHNetworkResponseObjectCompletion)(id responseData, NSError *__nullable error);

@interface BookDataViewModel : NSObject

+(void)syncMethod:(DHNetworkResponseObjectCompletion)completion;
+(void)bookDataRequestOncompletion:(DHNetworkResponseResultCompletion)completion;
+ (void)add:(DHNetworkResponseObjectCompletion)completion;
@end

NS_ASSUME_NONNULL_END
