//
//  UserAssembler.h
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户信息解析
 */
@interface UserAssembler : BackendAssembler
#pragma UserGrade
-(NSArray *)gradeListWithJSON:(NSArray *)JSON;
-(NSArray *)gradeAddListWithJSON:(NSArray *)JSON;

#pragma UserFav
- (NSArray *)userFavGoodsList:(NSArray *)goodslistJSON;
- (COLLECT_GOODS *)favGoods:(NSDictionary *)JSON;

#pragma UserAddress
- (ADDRESS *)address:(NSDictionary *)JSON;
- (NSArray *)listAddresses:(NSArray *)addressesJSON;

#pragma UserLike
- (NSArray *)userLikeGoodsList:(NSArray *)goodslistJSON;
- (COLLECT_GOODS *)collectGoods:(NSDictionary *)JSON;

#pragma UserProfile
- (USER *)user:(NSDictionary *)anUser;
- (AccessToken *)accessToken:(NSDictionary *)anTokenJson;

#pragma UserInfomation
- (NSArray *)userInformationList:(NSArray *)goodslistJSON;

#pragma UserInfomation
- (NSArray *)userCouponList:(NSArray *)goodslistJSON;
- (COLLECT_GOODS *)coupon:(NSDictionary *)JSON;

@end
