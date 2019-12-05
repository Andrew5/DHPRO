//
//  RegionMode.m
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "RegionMode.h"

@implementation RegionMode

-(RegionMode *)SetassignmentRegionMode:(NSDictionary *)dict
{
    if (dict&&[dict count]>0) {
        if ([dict objectForKey:@"add_time"]&&[[dict objectForKey:@"add_time"] length]>0) {
            self.add_time = [dict objectForKey:@"add_time"];
        }
        if ([dict objectForKey:@"id"]&&[[dict objectForKey:@"id"] length]>0) {
            self.ID = [dict objectForKey:@"id"];
        }
        if ([dict objectForKey:@"name"]&&[[dict objectForKey:@"name"] length]>0) {
            self.Name = [dict objectForKey:@"name"];
        }
        if ([dict objectForKey:@"title"]&&[[dict objectForKey:@"title"] length]>0) {
            self.Name = [dict objectForKey:@"title"];
        }
        if ([dict objectForKey:@"expressType"]&&[dict objectForKey:@"expressType"]) {
            self.expressType = [[dict objectForKey:@"expressType"] integerValue];
        }
        if ([dict objectForKey:@"ordid"]&&[[dict objectForKey:@"ordid"] length]>0) {
            self.ordid = [dict objectForKey:@"ordid"];
        }
        if ([dict objectForKey:@"pid"]&&[[dict objectForKey:@"pid"] length]>0) {
            self.pid = [dict objectForKey:@"pid"];
        }
        if ([dict objectForKey:@"spid"]&&[[dict objectForKey:@"spid"] length]>0) {
            self.spid = [dict objectForKey:@"spid"];
        }
        if ([dict objectForKey:@"status"]&&[[dict objectForKey:@"status"] length]>0) {
            self.status = [dict objectForKey:@"status"];
        }
    }
    return self;
}

@end
