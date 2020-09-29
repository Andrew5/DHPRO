//
//  SBApplicationController.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/26.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBApplicationController : NSObject
+(SBApplicationController*)sharedInstance;
-(NSArray*)allApplications;
@end

NS_ASSUME_NONNULL_END
