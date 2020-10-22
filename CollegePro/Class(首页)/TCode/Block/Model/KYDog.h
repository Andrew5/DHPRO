//
//  KYDog.h
//  15
//
//  Created by jabraknight on 2019/4/9.
//  Copyright © 2019 大爷公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 观察者需要实现的协议
@protocol MyProtocol <NSObject>
- (void)doSomething;
@end

@class KYUser;
@interface KYDog : NSObject<MyProtocol>
/** 狗的名字 */
@property (nonatomic, strong) NSString *name;
/** 狗的年龄 */
@property (nonatomic, assign) int age;
/** 狗的城市 */
@property (nonatomic, strong) NSString *city;

@property (strong, nonatomic)   NSMutableData            *printerData;

//-(void)loadNameValue:(NSString *)na;
- (void)changeName;
- (void)getIvars;
- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset;
@end

@interface KYUser : NSObject
{
    @public
    NSString *_can_not_observer_name;
    
    NSString *_sex;
}
/** ID */
@property (nonatomic, strong) NSString *sex;
/** 狗 */
@property (nonatomic, strong) KYDog *dog;
/** 数组 */
@property (nonatomic, strong) NSMutableArray *arr;

@end

NS_ASSUME_NONNULL_END
