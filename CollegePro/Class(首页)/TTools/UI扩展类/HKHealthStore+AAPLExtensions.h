//
//  HKHealthStore+AAPLExtensions.h
//  MPHealthProject
//
//  Created by plum on 17/6/17.
//  Copyright © 2017年 plum. All rights reserved.
//

#import <HealthKit/HealthKit.h>
//@import HealthKit;
@interface HKHealthStore (AAPLExtensions)
- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(NSArray *results, NSError *error))completion;

@end
