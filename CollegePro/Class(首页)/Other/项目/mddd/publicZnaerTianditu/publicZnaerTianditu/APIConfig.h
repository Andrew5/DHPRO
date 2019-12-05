//
//  APIConfig.h
//  ZLYDoc
//  API信息
//  Created by Ryan on 14-4-14.
//  Copyright (c) 2014年 ZLY. All rights reserved.
//

#import <Foundation/Foundation.h>
/***************SERVER HOST***************/

//#define SERVER_HOST @"http://172.16.50.104:8080"
#define SERVER_HOST @"http://112.94.224.232:8080"
//#define SERVER_HOST @"http://www.znaer.net"
/***************SERVER API***************/

//用户协议
#define USER_DEAL @"http://112.94.224.232:8080/xieyi.html"
//登录
#define API_LOGIN @"/iznaer/user/login.do"

//注册
#define API_REGISTER @"/iznaer/user/register.do"

//共享我的位置
#define SHARE_MY_LOCATION @"/iznaer/location/{token}/addLocation.do"

//获取最近位置信息
#define GET_RECENTLY @"/iznaer/location/{token}/getLastLocation.do"

//好友申请
#define APPLY_FRIEND @"/iznaer/equip/{token}/applyEquip.do"

//获取好友申请列表
#define GET_AUDIT_LIST @"/iznaer/equip/{token}/getAuditList.do"

//好友申请审核
#define AUDIT_FRIEND @"/iznaer/equip/{token}/auditEquip.do"

//搜寻好友
#define SEARCH_FRIENDS @"/iznaer/equip/{token}/findEquidList.do"

//获取联系人信息
#define GET_FRIEND_INFO @"/iznaer/equip/{token}/getEquipDetail.do"

//获取所有好友
#define GET_ALL_FRIENDS @"/iznaer/equip/{token}/getFreindEquipList.do"

//删除好友
#define DEL_FRIEND @"/iznaer/equip/{token}/removeFreindEquip.do"

//验证手机通讯录中的联系人
#define VALI_CONTACTS @"/iznaer/equip/{token}/getMobileEquipList.do"

//修改用户个人资料
#define ALERT_USER_INFO @"/iznaer/equip/{token}/updateEquip.do"

//上传头像
#define UPLOAD_HEAD_IMAGE @"/iznaer/equip/{token}/updateEquipIcon.do"
//获取最近联系人列表
#define GET_RECENT_FRIEND @"/iznaer/equip/{token}/getLatestEquipList.do"

//指定地图范围内搜索
#define SEARCH_FRIEND_IN_AREA @"/iznaer/equip/{token}/getCurrentFriendList.do"
//搜索附近的人
#define SEARCH_NEARY_FRIEND  @"/iznaer/equip/{token}/getNearEquipList.do"

//获取短信验证
#define GET_MSG_SMS @"/iznaer/message/sms.do"

@interface APIConfig : NSObject

@end