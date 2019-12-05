//
//  DetailDistinationModel.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DetailDistinationModel.h"

@implementation DetailDistinationModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"InfoDataModel"};
}
@end

@implementation InfoDataModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"hot_city":@"HotcityModel",@"hot_mguide":@"HotmguideModel",@"discount":@"DiscountModel"};
}
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id",@"discount":@"new_discount"};
}


@end

@implementation HotmguideModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}


@end

@implementation HotcityModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}


@end

@implementation DiscountModel
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}


@end