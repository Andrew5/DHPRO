//
//  WKVCLifeCircleRecordManager.h
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WKVCLifeCircleRecordModel : NSObject

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong) NSString * className;
@property (nonatomic, strong) NSString * methodName;
@property (nonatomic, strong) NSString * address;

@end

@interface WKVCLifeCircleRecordManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray <WKVCLifeCircleRecordModel *> *models;

+ (instancetype)sharedVCLifeCircleRecordManager;

+ (void)addRecordWithVC:(UIViewController *)vc methodName:(NSString *)methodNmae;

@end
