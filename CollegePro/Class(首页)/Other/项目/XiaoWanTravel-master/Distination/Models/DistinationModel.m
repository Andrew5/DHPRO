//
//  DistinationModel.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "DistinationModel.h"

@implementation DistinationModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"DataModel"};
}

@end
@implementation DataModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"hot_country":@"HotCountryModel",@"country":@"CountryModel"};
}
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}
@end

@implementation HotCountryModel


+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}
@end

@implementation CountryModel

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}

@end