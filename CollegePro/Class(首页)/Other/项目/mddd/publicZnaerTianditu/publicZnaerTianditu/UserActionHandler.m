//
//  UserActionHandler.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "UserActionHandler.h"
#import "APIConfig.h"
#import "SVProgressHUD.h"
#import "BaseEntity.h"

@implementation UserActionHandler
@synthesize httpClicent;

-(id)init{
    self = [super init];
    
    if (self) {
        httpClicent = [RTHttpClient defaultClient];
    }
    
    return self;
}

-(void)shareUserLocation:(NSDictionary *)params{
  
    NSString *url = [BaseHandler requestUrlByTokenWithPath:SHARE_MY_LOCATION];
    
    [httpClicent requestWithPath:url method:RTHttpRequestGet parameters:params prepareExecute:^{
        //[SVProgressHUD showWithStatus:@"正在共享位置..."];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
       
        BaseEntity *entity = [BaseEntity parseResponseStatusJSON:responseObject];
        
//        if (entity.code == 200) {
//            [SVProgressHUD showSuccessWithStatus:@"位置共享成功"];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:entity.des];
//        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"共享失败"];
    }];
}

@end
