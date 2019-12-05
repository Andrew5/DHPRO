//
//  FriendManagerHandler.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/4.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "FriendManagerHandler.h"
#import "APIConfig.h"
#import "SVProgressHUD.h"
#import "BaseEntity.h"
#import "MJExtension.h"
#import "UserInfoStorage.h"
#import "VerifyUtil.h"
#import "UserEntity.h"
@implementation FriendManagerHandler

@synthesize httpClicent;

-(id)init{
    self = [super init];
    
    if (self) {
        httpClicent = [RTHttpClient defaultClient];
    }
    
    return self;

}

-(void)searchFriendWithNum:(NSString *)num{
   
    UserEntity *entity = [[UserInfoStorage defaultStorage] getUserInfo];
    NSDictionary *params;
    
    if ([VerifyUtil validateMobile:num]) {
        params = @{@"equipId":entity.equipID,@"mobileNumber":num};
    }
    else{
        params = @{@"equipId":entity.equipID,@"equipCode":num};
    }
    
    NSString *url = [BaseHandler requestUrlByTokenWithPath:SEARCH_FRIENDS];
    
    __unsafe_unretained FriendManagerHandler *safeself = self;
   
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"查找中..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
    
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD dismiss];
            NSDictionary *responseDic = responseObject;
            NSArray *results = [responseDic objectForKey:@"results"];
            if (results.count > 0) {
                //把字典数组转为实体数组
                results = [FriendEntity objectArrayWithKeyValuesArray:results];
                //传递给ViewController
                safeself.successBlock(results);
            }
            else{
                
                [SVProgressHUD showErrorWithStatus:@"没有该号码的账号"];
            }
            
        }
                 
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查找失败"];
    }];
    
}

-(void)getFriendInfo:(NSString *)equipID{
    
    UserInfoStorage *storage = [UserInfoStorage defaultStorage];
    NSDictionary *param = @{@"masterEquipId":[storage getUserInfo].equipID,@"equipId":equipID};
    NSString *url = [BaseHandler requestUrlByTokenWithPath:GET_FRIEND_INFO];
    
    __unsafe_unretained FriendManagerHandler *safeself = self;

    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:param prepareExecute:^{
        [SVProgressHUD showWithStatus:@"获取信息中..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD dismiss];
            
            NSDictionary *info = [responseObject objectForKey:@"results"];
            
            FriendEntity *friend = [FriendEntity objectWithKeyValues:info];
           
            NSDictionary *retData = @{@"friend":friend,REQUEST_ACTION:[NSNumber numberWithInt:GET_FRIEND_INFO_OPT]};
            
            safeself.successBlock(retData);
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
}


-(void)applyMakeFriend:(NSDictionary *)params{
    NSString *url = [BaseHandler requestUrlByTokenWithPath:APPLY_FRIEND];
    __unsafe_unretained FriendManagerHandler *safeself = self;
    [httpClicent requestWithPath:url method:RTHttpRequestPost parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在申请..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功,请等待好友验证"];
            NSDictionary *retData = @{REQUEST_ACTION:[NSNumber numberWithInt:APPLY_AUDIT_OPT]};
            safeself.successBlock(retData);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];

}
#pragma mark -
#pragma mark -获取好友最新位置

-(void)getFriendCurrentLocation:(NSString *)equipId{
    NSString *url=[BaseHandler requestUrlByTokenWithPath:GET_RECENTLY];
    
     __unsafe_unretained FriendManagerHandler *safeself = self;
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:equipId,@"equipId", nil];
    
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:param prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在获取....."];
    }success:^(NSURLSessionDataTask *task,id responseObjec){
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObjec];
        if (entity.code==200) {
            [SVProgressHUD dismiss];
            NSDictionary *infor=[responseObjec objectForKey:@"results"];
            NSDictionary *retDic = @{RET_RESULT:infor,REQUEST_ACTION:[NSNumber numberWithInt:GET_FRIEND_LOCATION_OPT]};
            safeself.successBlock(retDic);
        }
        else{
          //  NSLog(entity.descriptions);
            [SVProgressHUD showErrorWithStatus:@"获取位置信息失败!"];
        }
        
        
    }failure:^(NSURLSessionDataTask *task,NSError *erro){
        
        [SVProgressHUD showErrorWithStatus:@"获取位置信息失败!"];
    
    }];
}

#pragma mark -
#pragma mark -获取所有好友

-(void)searchContacts:(NSString *)equipId{
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:equipId,@"equipId", nil];
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:GET_ALL_FRIENDS];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:param prepareExecute:^{
        [SVProgressHUD showWithStatus:@"查找中..."];
    } success:^(NSURLSessionDataTask *task,id responseObject ){
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        
        if (entity.code==200) {
            [SVProgressHUD dismiss];
            NSDictionary *contactInfor=responseObject;
            NSArray *results = [contactInfor objectForKey:@"results"];
            results = [FriendEntity objectArrayWithKeyValuesArray:results];
            NSDictionary *dic = @{RET_RESULT:results,REQUEST_ACTION:[NSNumber numberWithInt:GET_ALL_FRIENDS_OPT]};
            
            safeself.successBlock(dic);
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
        
    }failure:^(NSURLSessionDataTask *task ,NSError *error){
        
    }];
    
}

#pragma mark -
#pragma mark -获取待审核好友

-(void)searchNewFriend:(NSString *)equipId{
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:equipId,@"equipId", nil];
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:GET_AUDIT_LIST];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:param prepareExecute:^{
        [SVProgressHUD showWithStatus:@"查找中..."];
    } success:^(NSURLSessionDataTask *task,id responseObject ){
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code==200) {
            [SVProgressHUD dismiss];
            NSDictionary *responseInfor=responseObject;
            NSArray *datas = [responseInfor objectForKey:@"results"];
            
            datas = [FriendEntity objectArrayWithKeyValuesArray:datas];
            
            NSDictionary *retResult = @{RET_RESULT:datas,REQUEST_ACTION:[NSNumber numberWithInt:REQUEST_FRIEND_OPT]};
            
            safeself.successBlock(retResult);
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
        
    }failure:^(NSURLSessionDataTask *task ,NSError *error){
        
    }];
    
    
}


#pragma mark -
#pragma mark -好友审核
-(void)audit:(NSString *)equipId andFriend:(FriendEntity *)friend andState:(NSString*)state{
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:equipId,@"equipId",friend.equipId,@"applyEquipId",state,@"state", nil];
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:AUDIT_FRIEND];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:param prepareExecute:^{
        [SVProgressHUD showWithStatus:@"请稍等..."];
    } success:^(NSURLSessionDataTask *task,id responseObject ){
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code==200) {
            if ([state isEqualToString:@"1"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            }
            else if([state isEqualToString:@"2"]){
                
                [SVProgressHUD showSuccessWithStatus:@"已经拒绝"];
            }
            NSDictionary *blockInfo=@{RET_RESULT:@"success",REQUEST_ACTION:[NSNumber numberWithInt:AUDIT_FRIEND_OPT],@"state":state,@"friend":friend};
            safeself.successBlock(blockInfo);
            
        }
        else{
            if ([state isEqualToString:@"1"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加失败"];
            }
            else if([state isEqualToString:@"2"]){
                
                [SVProgressHUD showSuccessWithStatus:@"拒绝失败"];
            }
            
        }
        
        
    }failure:^(NSURLSessionDataTask *task ,NSError *error){
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    
    
}

-(void)deleteFrient:(FriendEntity *)friendEntity;{
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *user = [storage getUserInfo];
    NSDictionary *params = @{@"equipId":user.equipID,@"friendEquipId":friendEntity.equipId};
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:DEL_FRIEND];
   
    __unsafe_unretained FriendManagerHandler *safeself=self;
    
    [httpClicent requestWithPath:url method:RTHttpRequestPost parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在删除..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
             NSDictionary *dic = @{RET_RESULT:friendEntity,REQUEST_ACTION:[NSNumber numberWithInt:DEL_FRIEND_OPT]};
            
            safeself.successBlock(dic);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"操作异常"];
    }];
}

-(void)valiMobileContact:(NSString *)contacts{
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *user = [storage getUserInfo];
    NSDictionary *params = @{@"equipId":user.equipID,@"mobileNumbers":contacts};
    NSString *url=[BaseHandler requestUrlByTokenWithPath:VALI_CONTACTS];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在查询..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD dismiss];
            NSString *retResult = [responseObject objectForKey:@"results"];
            NSDictionary *retDic = @{RET_RESULT:retResult,REQUEST_ACTION:[NSNumber numberWithInt:VALI_CONTACTS_OPT]};
            safeself.successBlock(retDic);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"查询失败"];
       
    }];
}

-(void)getRecentFriend{
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *user = [storage getUserInfo];
    NSDictionary *params = @{@"equipId":user.equipID};
    NSString *url=[BaseHandler requestUrlByTokenWithPath:GET_RECENT_FRIEND];
   
    __unsafe_unretained FriendManagerHandler *safeself=self;
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:params prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
           
            NSString *retResult = [responseObject objectForKey:@"results"];
            NSDictionary *retDic = @{RET_RESULT:retResult,REQUEST_ACTION:[NSNumber numberWithInt:VALI_CONTACTS_OPT]};
            safeself.successBlock(retDic);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)searchFriendInArea:(NSDictionary *)params{
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *user = [storage getUserInfo];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsDic setObject:user.equipID forKey:@"equipId"];
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:SEARCH_FRIEND_IN_AREA];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:paramsDic prepareExecute:^{
       
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD dismiss];
            NSString *retResult = [responseObject objectForKey:@"results"];
            NSDictionary *retDic = @{RET_RESULT:retResult,REQUEST_ACTION:[NSNumber numberWithInt:SEARCH_FRIEND_IN_AREA_OPT]};
            safeself.successBlock(retDic);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        
    }];


}

-(void)searchNearFriend:(NSDictionary *)params{
    
    UserInfoStorage *storage = [[UserInfoStorage alloc]init];
    UserEntity *user = [storage getUserInfo];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsDic setObject:user.equipID forKey:@"equipId"];
    
    NSString *url=[BaseHandler requestUrlByTokenWithPath:SEARCH_NEARY_FRIEND];
    
    __unsafe_unretained FriendManagerHandler *safeself=self;
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:paramsDic prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
           
            NSArray *arrayResult = [responseObject objectForKey:@"results"];
            NSDictionary *retDic = @{RET_RESULT:arrayResult,REQUEST_ACTION:[NSNumber numberWithInt:SEARCH_NEARY_FRIEND_OPT]};
            safeself.successBlock(retDic);
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
            safeself.successBlock(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
}

@end
