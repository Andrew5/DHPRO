//
//  UserActionHandler.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseHandler.h"
#import "RTHttpClient.h"
//用户行为操作
@interface UserActionHandler : BaseHandler

@property(nonatomic,copy)CompleteBlock completeBlock;

@property(nonatomic,copy)SuccessBlock  successBlock;

@property(nonatomic,copy)FailedBlock   failedBlock;

@property(nonatomic,strong)RTHttpClient *httpClicent;

-(void)shareUserLocation:(NSDictionary *)params;

@end
