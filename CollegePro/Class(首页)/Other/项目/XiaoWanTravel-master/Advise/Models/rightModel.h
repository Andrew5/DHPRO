//
//  rightModel.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/29.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class DaModel,GuidesModel;
@interface rightModel : NSObject
@property(nonatomic,strong)NSMutableArray *data;
@end

@interface DaModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)NSMutableArray *guides;
@end

@interface GuidesModel : NSObject
@property(nonatomic,copy)NSString *guide_id;
@property(nonatomic,copy)NSString *guide_cnname;
@property(nonatomic,copy)NSString *guide_enname;
@property(nonatomic,copy)NSString *guide_pinyin;
@property(nonatomic,copy)NSString *category_id;
@property(nonatomic,copy)NSString *category_title;
@property(nonatomic,copy)NSString *country_id;
@property(nonatomic,copy)NSString *country_name_cn;
@property(nonatomic,copy)NSString *country_name_en;
@property(nonatomic,copy)NSString *country_name_py;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *cover_updatetime;
@property(nonatomic,assign)NSInteger download;
@property(nonatomic,copy)NSString *file;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *update_log;
@property(nonatomic,copy)NSString *update_time;


@end