//
//  WKVCLifeCircleRecordManager.m
//  MKWeekly
//
//  Created by wangkun on 2018/3/22.
//  Copyright © 2018年 zymk. All rights reserved.
//

#import "WKVCLifeCircleRecordManager.h"

@implementation WKVCLifeCircleRecordModel



@end

@interface WKVCLifeCircleRecordManager ()

@property (nonatomic, strong) NSMutableArray <WKVCLifeCircleRecordModel *> *models;

@end

@implementation WKVCLifeCircleRecordManager

+ (instancetype)sharedVCLifeCircleRecordManager
{
    static WKVCLifeCircleRecordManager * vclcrm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vclcrm = [WKVCLifeCircleRecordManager new];
    });
    return vclcrm;
}

+ (void)addRecordWithVC:(UIViewController *)vc methodName:(NSString *)methodNmae
{
    WKVCLifeCircleRecordManager * m = [self sharedVCLifeCircleRecordManager];
    WKVCLifeCircleRecordModel * model = [WKVCLifeCircleRecordModel new];
    model.time = [NSDate date].timeIntervalSince1970;
    model.className = NSStringFromClass([vc class]) ;
    model.methodName = methodNmae;
    model.address = [NSString stringWithFormat:@"%p",vc];
    [m.models addObject:model];
}

- (NSMutableArray<WKVCLifeCircleRecordModel *> *)models
{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
