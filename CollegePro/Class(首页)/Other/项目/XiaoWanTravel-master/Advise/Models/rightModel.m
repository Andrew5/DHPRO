//
//  rightModel.m
//  XiaoWanTravel
//
//  Created by xiao on 16/7/29.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import "rightModel.h"

@implementation rightModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"data":@"DaModel"};
}

@end

@implementation DaModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"guides":@"GuidesModel"};
}
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
}
@end

@implementation GuidesModel


@end
