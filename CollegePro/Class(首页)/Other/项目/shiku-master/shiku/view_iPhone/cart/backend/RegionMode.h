//
//  RegionMode.h
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionMode : NSObject

@property(nonatomic ,strong) NSString * add_time;

@property(nonatomic ,strong) NSString * ID;

@property(nonatomic ,strong) NSString * Name;

@property(nonatomic ,strong) NSString * ordid;

@property(nonatomic ,strong) NSString * pid;

@property(nonatomic ,strong) NSString * remark;

@property(nonatomic ,strong) NSString * spid;

@property(nonatomic ,strong) NSString * status;

@property(nonatomic ,assign) NSInteger  expressType;

-(RegionMode *)SetassignmentRegionMode:(NSDictionary *)dict;

@end
