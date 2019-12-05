//
//  FriendManagerHandler.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/4.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseHandler.h"
#import "RTHttpClient.h"
#import "FriendEntity.h"

typedef enum {
    GET_ALL_FRIENDS_OPT,//获取好友列表
    GET_FRIEND_LOCATION_OPT,//获取好友最近位置
    DEL_FRIEND_OPT,//删除好友
    REQUEST_FRIEND_OPT,//获取新好友审核列表
    AUDIT_FRIEND_OPT,//通过好友审核
    GET_FRIEND_INFO_OPT,//获取好友详细信息
    APPLY_AUDIT_OPT,//申请好友审核
    VALI_CONTACTS_OPT,//电话簿好友验证查询
    SEARCH_FRIEND_IN_AREA_OPT,//地图范围查询好友
    SEARCH_NEARY_FRIEND_OPT//查找附近的人
}optition;

#define REQUEST_ACTION @"requestAction"

#define RET_RESULT @"ret_result"

//好友管理操作的handler
@interface FriendManagerHandler : BaseHandler

@property(nonatomic,strong)RTHttpClient *httpClicent;

@property(nonatomic,copy)CompleteBlock completeBlock;

@property(nonatomic,copy)SuccessBlock  successBlock;

@property(nonatomic,copy)FailedBlock   failedBlock;

//搜索好友
-(void)searchFriendWithNum:(NSString *)num;
//查看好友详细信息
-(void)getFriendInfo:(NSString *)equipID;
//申请添加为好友
-(void)applyMakeFriend:(NSDictionary *)params;
//获取好友最近位置信息
-(void)getFriendCurrentLocation:(NSString *)equipId;
//从网络获取所有好友
-(void)searchContacts:(NSString *)equipId;
//获取待审核好友
-(void)searchNewFriend:(NSString *)equipId;
//好友审核
-(void)audit:(NSString *)equipId andFriend:(FriendEntity *)friend andState:(NSString*)state;
//删除好友
-(void)deleteFrient:(FriendEntity *)friendEntity;
//手机本地通讯录好友查询
-(void)valiMobileContact:(NSString *)contacts;
//获取最近查询好友列表
-(void)getRecentFriend;
//搜索指定区域的好友
-(void)searchFriendInArea:(NSDictionary *)params;
//搜索附近的人
-(void)searchNearFriend:(NSDictionary *)params;
@end
