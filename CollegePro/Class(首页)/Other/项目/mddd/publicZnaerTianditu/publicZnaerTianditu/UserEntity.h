//
//  UserEntity.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/31.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseEntity.h"

//用户登录信息实体
@interface UserEntity : BaseEntity <NSCoding>

@property(nonatomic,strong)NSString *loginName;
@property(nonatomic)NSString *to;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *equipID;
@property(nonatomic       ) Gender   gender;
@property(nonatomic,strong)NSString *equipIcon;
@property(nonatomic,strong)NSString *remark;

@end
