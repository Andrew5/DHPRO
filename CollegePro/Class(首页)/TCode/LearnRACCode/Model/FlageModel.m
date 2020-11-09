//
//  FlageModel.m
//  TestDemo
//
//  Created by jabraknight on 2020/11/9.
//  Copyright © 2020 黄定师. All rights reserved.
//

#import "FlageModel.h"

@implementation FlageModel
//- (instancetype)flageWithAccount:(NSString *)account
//  Age:(NSString *)age
// Name:(NSString *)name
//  Sex:(NSString *)sex
//                           Token:(NSString *)token{
//
//}
+ (instancetype)flageWithDict:(NSDictionary *)dict{
    FlageModel *flage = [[self alloc]init];
    [flage setValuesForKeysWithDictionary:dict];
    return  flage;
}
@end
