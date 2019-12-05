//
//  DistinationModel.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class DataModel,HotCountryModel,CountryModel;

@interface DistinationModel : NSObject
@property(nonatomic,strong)NSMutableArray *data;
@end

@interface DataModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *cnname;
@property(nonatomic,copy)NSString *enname;
@property(nonatomic,strong)NSMutableArray *hot_country;
@property(nonatomic,strong)NSMutableArray *country;
@end

@interface HotCountryModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property (nonatomic,copy) NSString* cnname;
@property (nonatomic,copy) NSString* enname;
@property (nonatomic,copy) NSString* photo;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,copy) NSString *label;
@property (nonatomic,assign)NSInteger flag;

@end

@interface CountryModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property (nonatomic,copy) NSString* cnname;
@property (nonatomic,copy) NSString* enname;
@property (nonatomic,copy) NSString* photo;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,copy) NSString *label;
@property (nonatomic,assign)NSInteger flag;

@end
