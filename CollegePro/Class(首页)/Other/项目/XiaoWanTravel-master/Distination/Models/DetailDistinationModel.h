//
//  DetailDistinationModel.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class InfoDataModel,HotcityModel,HotmguideModel,DiscountModel;
@interface DetailDistinationModel : NSObject
@property(nonatomic,strong)InfoDataModel *data;
@end

@interface InfoDataModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *cnname;
@property(nonatomic,copy)NSString *enname;
@property(nonatomic,copy)NSString *overview_url;
@property(nonatomic,copy)NSString *entryCont;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)NSMutableArray *hot_city;
@property(nonatomic,strong)NSMutableArray *hot_mguide;
@property(nonatomic,strong)NSMutableArray *discount;
@end

@interface HotcityModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *cnname;
@property(nonatomic,copy)NSString *enname;
@property(nonatomic,copy)NSString *photo;
@end

@interface HotmguideModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,copy)NSString *avatar;
@end

@interface DiscountModel : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *priceoff;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *expire_date;
@end