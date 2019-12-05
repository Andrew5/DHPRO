//
//  WKVCDeallocManger.h
//  MKWeekly
//
//  Created by wangkun on 2018/3/21.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WKDeallocModel : NSObject

@property (nonatomic, strong, readonly) NSString * className;
@property (nonatomic, strong, readonly) NSString * address;
@property (nonatomic, assign, readonly) BOOL isNeedRelease;
@property (nonatomic, strong, readonly) UIImage * img;
@property (nonatomic, assign, readonly) NSTimeInterval releaseTime;


+ (instancetype)createWithObject:(id)object;

- (BOOL)isEqual:(id)object;

@end

@interface WKVCDeallocManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <WKDeallocModel *> * models;
@property (nonatomic, strong, readonly) NSMutableArray <WKDeallocModel *> * warnningModels;
@property (nonatomic, assign) BOOL isWarnning;
+ (instancetype)sharedVCDeallocManager;

+ (void)addWithObject:(id)object;
+ (void)releaseWithObject:(id)object;
+ (void)removeWithObject:(id)object;

+ (NSArray *)findRecordModelWithDeallocModel:(WKDeallocModel *)model;
@end
