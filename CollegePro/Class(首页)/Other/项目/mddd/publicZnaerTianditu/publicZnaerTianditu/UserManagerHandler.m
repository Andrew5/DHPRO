//
//  UserManagerHandler.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/30.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "UserManagerHandler.h"
#import "APIConfig.h"
#import "SVProgressHUD.h"
#import "UserEntity.h"
#import "MJExtension.h"
#import "BaseDao.h"
//#import "XGPush.h"
#import "AppDelegate.h"
@implementation UserManagerHandler
@synthesize httpClicent;
@synthesize userStorage;
-(id)init{
    self = [super init];
    
    if (self) {
        httpClicent = [RTHttpClient defaultClient];
        userStorage = [UserInfoStorage defaultStorage];
    }
    
    return self;
}

-(void)doRegisterWithParams:(NSDictionary *)params
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [params1 setObject:appDelegate.deviceTokenStr forKey:@"token"];
    
    NSString *url = [BaseHandler requestUrlWithPath:API_REGISTER];
    __unsafe_unretained UserManagerHandler *safeself = self;
    [httpClicent requestWithPath:url method:RTHttpRequestPost parameters:params1 prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在注册..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        
        if (entity.status == 1) {
            NSDictionary *responseDic = responseObject;
            UserEntity *userEntity = [UserEntity objectWithKeyValues:responseDic];
            [userStorage saveUserInfo:userEntity];//保存用户信息
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [self registerXGPush:userEntity.equipID];
            safeself.successBlock(userEntity);//通知页面处理成功
        }else {
            [SVProgressHUD showErrorWithStatus:entity.des];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    }];
}

-(void)doLoginWithParams:(NSDictionary *)params
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithDictionary:params];
    
 //  [params1 setObject:appDelegate.deviceTokenStr forKey:@"token"];
    [params1 setObject:@"d74075ed8895b35e89ecd0e9fe86f6be573ddfc342e01a0f034ebe4bd22bc7d5" forKey:@"token"];
    
    NSString *url = [BaseHandler requestUrlWithPath:API_LOGIN];
    
    __unsafe_unretained UserManagerHandler *safeself = self;

    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:params1 prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在登录..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
       
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        
        if (entity.status == 1) {
            NSDictionary *responseDic = responseObject;
            UserEntity *userEntity = [UserEntity objectWithKeyValues:responseDic];
            [userStorage saveUserInfo:userEntity];//保存用户信息
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self registerXGPush:userEntity.equipID];
            safeself.successBlock(userEntity);
        }else {
            [SVProgressHUD showErrorWithStatus:entity.msg];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];

}

//注册推送信息
-(void)registerXGPush:(NSString *)account{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
   
    //这里注销原来设置的别名
//    [XGPush setAccount:@"*"];
//    
//    //注册别名
//    [XGPush setAccount:account];
//   
//    //这里设置别名后注册设备
//    [XGPush registerDevice:appDelegate.deviceToken];

}

-(void)doLoginOut{
    //删除个人信息
    [userStorage delUserInfo];
    BaseDao *dao = [[BaseDao alloc]init];
    [dao clearAllTable];//清空数据库
}

-(void)alertUserInfo:(NSDictionary *)params{
    NSString *url = [BaseHandler requestUrlByTokenWithPath:ALERT_USER_INFO];
    
    __unsafe_unretained UserManagerHandler *safeself = self;
    
    
    [httpClicent requestWithPath:url method:RTHttpRequestPost parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"保存中..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
       
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            [SVProgressHUD dismiss];
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            safeself.successBlock(params);

        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }];

}

-(void)uploadHeadImage:(UIImage *)image{
    NSString *url = [BaseHandler requestUrlByTokenWithPath:UPLOAD_HEAD_IMAGE];
    UserInfoStorage *storage = [UserInfoStorage defaultStorage];
    NSString *equipID = [storage getUserInfo].equipID;
    NSDictionary *param= @{@"equipId":equipID};
    
     NSData *imageData = UIImageJPEGRepresentation(image,0.8);
    __unsafe_unretained UserManagerHandler *safeself = self;
    [httpClicent requestWithFile:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"equipIcon" fileName:@"equipIcon.jpg" mimeType:@"image/jpeg"];
       
    } prepareExecute:^{
        [SVProgressHUD showWithStatus:@"正在保存..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        if (entity.code == 200) {
            NSDictionary *results = [responseObject objectForKey:@"results"];
            NSString *equipIcon = [results objectForKey:@"equipIcon"];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            NSDictionary *retDic = @{@"image":image,@"equipIcon":equipIcon};
            safeself.successBlock(retDic);
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:entity.des];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }];
}

-(void)doValidatePhone:(NSString *)num
{
    NSString *url = [BaseHandler requestUrlWithPath:GET_MSG_SMS];
    __unsafe_unretained UserManagerHandler *safeself = self;
    NSDictionary *params = @{@"mobile":num};
    [httpClicent requestWithPath:url method:RTHttpRequestPost parameters:params prepareExecute:^{
        [SVProgressHUD showWithStatus:@"请等待..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        
        if (entity.status == 1) {
            [SVProgressHUD showSuccessWithStatus:@"验证码已发送，请注意查收"];
            safeself.successBlock(responseObject);//通知页面处理成功
        }else {
            [SVProgressHUD showErrorWithStatus:entity.msg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"验证码发送失败"];
    }];
}

@end
