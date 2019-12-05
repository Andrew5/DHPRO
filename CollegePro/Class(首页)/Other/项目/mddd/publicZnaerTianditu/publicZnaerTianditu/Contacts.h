//
//  Contact.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/24.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseEntity.h"

typedef enum {
    APP_USER, //未添加好友的app用户
    FRIEND_USER,//已经添加为好友的app用户
    NOT_USER //不是app用户
}USER_STATE;


@interface Contacts : BaseEntity

@property(nonatomic,strong)NSString *equipId;
//用户昵称
@property(nonatomic,retain)NSString *equipName;
//用户在电话通讯录里的姓名
@property(nonatomic,retain)NSString *phonename;
//注册手机号码
@property(nonatomic,retain)NSString *phone;
//用户头像地址
@property(nonatomic,retain)NSString *equipIcon;
//用户状态
@property(nonatomic)USER_STATE state;
@end
