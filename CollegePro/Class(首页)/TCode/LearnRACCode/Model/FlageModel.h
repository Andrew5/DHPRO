//
//  FlageModel.h
//  TestDemo
//
//  Created by jabraknight on 2020/11/9.
//  Copyright © 2020 黄定师. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlageModel : NSObject
@property (nonatomic,strong)NSString *account;
@property (nonatomic,strong)NSString *age;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *token;
+ (instancetype)flageWithDict:(NSDictionary *)dict;
//- (instancetype)flageWithAccount:(NSString *)account
//  Age:(NSString *)age
// Name:(NSString *)name
//  Sex:(NSString *)sex
//Token:(NSString *)token;
@end

NS_ASSUME_NONNULL_END
