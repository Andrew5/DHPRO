//
//  FriendEntity.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseEntity.h"

typedef enum {
    REQUEST_AUDIT,//邀请审核
    ACCEPT_AUDIT, //通过申请
    REJECT_AUDIT, //拒绝申请
    WAITE_AUDIT   //等待好友审核
}AuditState;

typedef NS_ENUM(NSInteger, RELATIONSHIP){
    STRANGER = 0,
    FRIEND = 1
};

@interface FriendEntity : BaseEntity<NSCoding>
//朋友id
@property(nonatomic,strong)NSString *equipId;
//昵称
@property(nonatomic,strong)NSString *equipName;
//头像地址
@property(nonatomic,strong)NSString *equipIcon;

@property(nonatomic,strong)NSString *equipCode;

@property(nonatomic,strong)NSString *qrCodeUrl;

@property(nonatomic,strong)NSString *dailyStart;

@property(nonatomic,strong)NSString *dailyEnd;

@property(nonatomic       ) int      runSpan;

@property(nonatomic,strong)NSString *expireDate;

@property(nonatomic,strong)NSString *remark;

@property(nonatomic,strong)NSString *applyDesc;//好友申请描述
//性别
@property(nonatomic       ) Gender     gender;
//申请好友时，审核状态
@property(nonatomic       ) AuditState auditState;

@property(nonatomic       )RELATIONSHIP relationship;
@end
