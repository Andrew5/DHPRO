//
//  UserManagerHandler.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/30.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"
#import "RTHttpClient.h"
#import "UserInfoStorage.h"
//用户管理逻辑处理类
@interface UserManagerHandler : BaseHandler

@property(nonatomic,strong)RTHttpClient *httpClicent;

@property(nonatomic,strong)UserInfoStorage *userStorage;

-(id)init;

//验证手机号码
-(void)doValidatePhone:(NSString *)num;

//用户注册
-(void)doRegisterWithParams:(NSDictionary *)params;

//用户登陆
-(void)doLoginWithParams:(NSDictionary *)params;

//用户退出
-(void)doLoginOut;

//修改用户个人资料
-(void)alertUserInfo:(NSDictionary *)params;

//个人头像上传
-(void)uploadHeadImage:(UIImage *)image;

@end
