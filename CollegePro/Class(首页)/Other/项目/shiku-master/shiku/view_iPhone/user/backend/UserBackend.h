//
//  UserBackend.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"
#import "Models.h"
#import "UserRepository.h"
#import "UserAssembler.h"
/**
 *  用户信息解析
 */
@interface UserBackend : Backend
@property (strong, nonatomic) UserRepository *repository;
@property (strong, nonatomic) UserAssembler *assembler;

+ (instancetype)shared;

#pragma userSetting 其他设置
-(RACSignal *)requestUpdateUserSetting:(NSInteger)type withValue:(NSString *)value;

#pragma Grade 品位
- (RACSignal *)requestGradeList;
-(RACSignal *)requestGradeAddList;
-(RACSignal *)requestAddOrRemoveGrade:(NSInteger)anGradeId isDelete:(BOOL)isDel;

#pragma 积分
- (RACSignal *)requestIntegrationList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestRemoveIntegrationItems:(NSMutableArray *)items;

#pragma 优惠券
- (RACSignal *)requestCouponList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestCheckoutCouponList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestCouponDetails:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestRemoveCouponItems:(NSMutableArray *)items;

#pragma UserInfomation 消息
- (RACSignal *)requestInfomationList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestRemoveInfomationItems:(NSMutableArray *)items;

#pragma UserFav 农户
- (RACSignal *)requestUserFavList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestAddUserFavItems:(GOODS *)item;
- (RACSignal *)requestRemoveUserFavItems:(NSMutableArray *)items;
-(RACSignal *)requestRemoveUserFavItems2:(NSMutableArray *)items;

#pragma UserAddress
- (RACSignal *)requestAddressList:(FILTER *)filter withUser:(USER *)anUser;
- (RACSignal *)requestUpdateAddress:(ADDRESS *)address;
- (RACSignal *)requestAddressWithID:(NSInteger)addressID user:(USER *)anUser;
- (RACSignal *)requestDelAddressWithID:(NSInteger)addressID user:(USER *)anUser;

#pragma UserLike
- (RACSignal *)requestUserLikeList:(FILTER *)filter withUser:(USER *)user;
- (RACSignal *)requestAddUserLikeItems:(GOODS *)item;
- (RACSignal *)requestRemoveUserLikeItems:(NSMutableArray *)items;

#pragma UserLogiin
- (RACSignal *)requestAuthenticate:(USER *)user;
- (RACSignal *)requestAuthenticateUserBind:(USER *)user;
- (RACSignal *)requestAuthenticateUserBindAdd:(USER *)user;
- (RACSignal *)requestRegister:(USER *)user;
- (RACSignal *)requestUser:(AccessToken *)accessToken;
- (RACSignal *)requestSaveUser:(USER *)user;
- (RACSignal *)requestUpdateUserAvatar:(USER *)user;//更新头像
-(RACSignal *)requestResetPsw:(USER *)user;//重置密码
-(RACSignal *)requestChangePsw:(USER *)user;//修改密码
-(RACSignal *)requestPhoneCode:(USER *)user;//请求短信验证码
-(void)clearStore;
- (USER *)restore;
- (AccessToken *)accessToken;

- (RACSignal *)requestPresident:(USER *)user autherCode:(NSString*)code;
@end
