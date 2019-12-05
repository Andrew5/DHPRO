//
//  RecentFriendStorage.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/30.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendEntity.h"
@interface RecentFriendStorage : NSObject

+(RecentFriendStorage *)defaultStorage;

-(void)saveFriend:(NSArray *)arrayEntity;

-(NSArray *)getAllFriend;

@end
