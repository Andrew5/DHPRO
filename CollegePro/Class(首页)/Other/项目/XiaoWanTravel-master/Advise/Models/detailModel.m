//
//  detailModel.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "detailModel.h"
#import "MJExtension.h"
@implementation detailModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"DatainfoModel"};
}

@end

@implementation DatainfoModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"mobile":@"MobileModel",@"authors":@"AuthorsModel",@"related_guides":@"RelateModel"};
}

@end

@implementation MobileModel


@end
@implementation AuthorsModel


@end
@implementation RelateModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}

@end
