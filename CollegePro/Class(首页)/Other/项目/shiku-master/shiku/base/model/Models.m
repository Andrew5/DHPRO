//
//  Models.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Models.h"

#define INVALID_USERNAME @"请输入正确的用户名"
#define INVALID_PASSWORD @"请输入正确的密码"
#define VALID_LOGIN @"登录中..."

@implementation USER
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        //self.user_id =[aDecoder decodeObjectForKey:@"userid"];
        self.user_id=[aDecoder decodeObjectForKey:@"userid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.name = [aDecoder decodeObjectForKey:@"username"];
        self.tele = [aDecoder decodeObjectForKey:@"tell"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.rank_level = [aDecoder decodeObjectForKey:@"ranklevel"];
        self.avatarimg = [aDecoder decodeObjectForKey:@"img"];
        self.msg_sys=[aDecoder decodeObjectForKey:@"msgsys"];
        self.msg_sales=[aDecoder decodeObjectForKey:@"msgsales"];
        self.msg_express=[aDecoder decodeObjectForKey:@"msgexpress"];
        self.order_shouhuo=[aDecoder decodeObjectForKey:@"ordershouhuo"];
        self.order_fukuan=[aDecoder decodeObjectForKey:@"orderfukuan"];
        self.order_fahuo=[aDecoder decodeObjectForKey:@"orderfahuo"];
        self.coupon_num=[aDecoder decodeObjectForKey:@"couponnum"];
        self.score=[aDecoder decodeObjectForKey:@"score"];
        self.weibo=[aDecoder decodeObjectForKey:@"weibo"];
        self.weixin=[aDecoder decodeObjectForKey:@"weixin"];
        self.qq=[aDecoder decodeObjectForKey:@"qq"];
        self.provence=[aDecoder decodeObjectForKey:@"provence"];
        self.city=[aDecoder decodeObjectForKey:@"city"];
        self.area=[aDecoder decodeObjectForKey:@"area"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.user_id forKey:@"userid"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.name forKey:@"username"];
    [aCoder encodeObject:self.tele forKey:@"tell"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.avatarimg forKey:@"img"];
    [aCoder encodeObject:self.msg_express forKey:@"msgexpress"];
    [aCoder encodeObject:self.msg_sales forKey:@"msgsales"];
    [aCoder encodeObject:self.msg_sys forKey:@"msgsys"];
    [aCoder encodeObject:self.order_fahuo forKey:@"orderfahuo"];
    [aCoder encodeObject:self.order_fukuan forKey:@"orderfukuan"];
    [aCoder encodeObject:self.order_shouhuo forKey:@"ordershouhuo"];
    [aCoder encodeObject:self.coupon_num forKey:@"couponnum"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.rank_level forKey:@"ranklevel"];
    [aCoder encodeObject:self.weixin forKey:@"weixin"];
    [aCoder encodeObject:self.weibo forKey:@"weibo"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.provence forKey:@"provence"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    
}
- (BOOL)authorized
{
    if (0 >= self.user_id || nil == self.token ||
        [@"" isEqualToString:self.token]) {
        return NO;
    }
    return YES;
}
- (NSError *)valid
{
    NSInteger errorCode = -1;
    NSDictionary *errorDescription;
    NSError *error;
    if (!(self.name && self.name.length > 0)) {
        errorCode = 1;
        errorDescription = @{ NSLocalizedDescriptionKey: INVALID_USERNAME };
    } else if (!(self.password && self.password.length > 0)) {
        errorCode = 2;
        errorDescription = @{ NSLocalizedDescriptionKey: INVALID_PASSWORD };
    }
    else{
        errorDescription = @{ NSLocalizedDescriptionKey: VALID_LOGIN };
    }
    
    error = [NSError errorWithDomain:@"UserAuthentication"
                                code:errorCode
                            userInfo:errorDescription];
    return error;
}

@end

@implementation AccessToken
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.userid = [aDecoder decodeObjectForKey:@"userid"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userid forKey:@"userid"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
}
- (BOOL)authorized
{
    if (0 >= self.userid || nil == self.accessToken ||
        [@"" isEqualToString:self.accessToken]) {
        return NO;
    }
    return YES;
}

@end


@implementation ORDER
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.order_info=[ORDER_INFO new];
        self.payment_item=[PAYMENT new];
        self.address_item=[ADDRESS new];
        self.shipping_item=[SHIPPING new];
    }
    return self;
}
@end
@implementation SHIPPING
@end
@implementation ORDER_INFO
@end
@implementation PAYMENT
@end
@implementation SHOP_ITEM
@end
@implementation CART_GOODS
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.img=[PHOTO new];
    }
    return self;
}
@end
@implementation PHOTO
@end
@implementation TOTAL

-(void)setValue:(id)value forKey:(NSString *)key
{
    NSLog(@"%@:%@",key,value);
}

-(void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
     NSLog(@"%@:%@",keyPath,value);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@:%@",key,value);

}

@end
@implementation ADDRESS
@end
@implementation GOODS
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.img=[PHOTO new];
        self.shop_img=[PHOTO new];
    }
    return self;
}

@end
@implementation SIMPLE_GOODS
@end
@implementation COLLECT_GOODS
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.img=[PHOTO new];
    }
    return self;
}
@end
@implementation FILTER
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.pagenation=[PAGINATION new];
    }
    return self;
}
@end
@implementation PAGINATION
- (BOOL)hasMore
{
    return self.page < self.total;
}
@end
@implementation CATEGORY
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.img=[PHOTO new];
    }
    return self;
}
@end
@implementation GOODS_DETAIL_INFO
@end
@implementation GOOD_ATTR
@end
@implementation HomeItems
@end