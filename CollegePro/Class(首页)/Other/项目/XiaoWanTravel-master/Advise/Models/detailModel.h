//
//  detailModel.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatainfoModel,MobileModel,AuthorsModel,RelateModel;
@interface detailModel : NSObject
@property(nonatomic,strong)DatainfoModel *data;
@end

@interface DatainfoModel : NSObject
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *cnname;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *cover_updatetime;
@property(nonatomic,copy)NSString *enname;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,assign)NSInteger download;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,strong)MobileModel *mobile;
@property(nonatomic,strong)NSMutableArray *authors;
@property(nonatomic,strong)NSMutableArray *related_guides;
@end

@interface MobileModel : NSObject
@property(nonatomic,copy)NSString *file;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger size;
@end

@interface AuthorsModel : NSObject
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *avatar;
@end

@interface RelateModel : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,copy)NSString *cnname;
@property(nonatomic,copy)NSString *enname;
@property(nonatomic,copy)NSString *country_name_cn;
@property(nonatomic,copy)NSString *country_name_en;
@property(nonatomic,copy)NSString *country_name_py;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *cover_updatetime;
@property(nonatomic,assign)NSInteger category_id;
@property(nonatomic,copy)NSString *category_title;
@property(nonatomic,assign)NSInteger country_id;
@property(nonatomic,assign)NSInteger download;
@property(nonatomic,copy)NSString *pinyin;
@property(nonatomic,copy)NSString *update_time;
@end