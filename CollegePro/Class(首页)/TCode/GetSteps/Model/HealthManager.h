//
//  HealthManager.h
//  MPHealthProject
//
//  Created by plum on 17/6/17.
//  Copyright © 2017年 plum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
@interface HealthManager : NSObject

@property(strong,nonatomic)HKHealthStore *healthStore;

+(id)shareInstance;

/*!
 *  @author Lcong, 18-08-13 17:04:38
 *
 *  @brief  获取当天实时步数
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 18-08-13 17:04:38
 *
 *  @brief  获取一定时间段步数
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 18-08-13 17:04:38
 *
 *  @brief  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

/*!
 *  @author Lcong, 18-08-13 17:04:38
 *
 *  @brief  当天时间段
 *
 *  @return ,,,
 */
+ (NSPredicate *)predicateForSamplesToday;

//获取公里数
- (void)getDistance:(void(^)(double value, NSError *error))completion;

/*
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion;
@end
