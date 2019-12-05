//
//  UserRepository.h
//  btc
//
//  Created by txj on 15/1/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户仓库
 */
@interface UserRepository : NSObject
/**
 *  清楚用户本地信息
 */
-(void)clearUserStore;
/**
 *  废弃
 */
-(void)clearAccessTokenStore;
/**
 * 从本地恢复信息
 *
 *  @return USER
 */
- (USER *)restore;
/**
 *  废弃
 *
 *  @return
 */
- (AccessToken *)restoreAccessToken;
/**
 *  保存用户到本地
 *
 *  @param user USER对象
 */
- (void)storage:(USER *)user;
/**
 *  废弃
 *
 *  @param accessToken
 */
- (void)storageToken:(AccessToken *)accessToken;
/**
 *  单例模式 使用此方法获取实例
 *
 */
+ (instancetype)shared;
@end
