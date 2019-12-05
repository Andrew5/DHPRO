//
//  UserAssembler.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserAssembler.h"

@implementation UserAssembler
#pragma Grade//品位
-(NSArray *)gradeAddListWithJSON:(NSArray *)JSON
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self gradeWithJSON:item withType:0]];
    return items;
}
-(NSArray *)gradeListWithJSON:(NSArray *)JSON
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self gradeWithJSON:item withType:1]];
    return items;
}
-(CATEGORY *)gradeWithJSON:(NSDictionary *)JSON withType:(NSInteger)type
{
    CATEGORY *grade = [[CATEGORY alloc] init];
    if (type==1) {
        NSMutableArray *children;
        NSArray *childrenJSON = [JSON objectForKey:@"items"];
        if (childrenJSON && childrenJSON.count > 0) {
            children = [[NSMutableArray alloc] initWithCapacity:childrenJSON.count];
            for (NSDictionary *childJSON in childrenJSON)
                [children addObject:[self gradeWithJSON:childJSON withType:0]];
        }
        grade.children = children;
    }
    grade.rec_id=[JSON objectForKey:@"id"];
    grade.name=[JSON objectForKey:@"name"];
    grade.img.small=[JSON objectForKey:@"img"];
    
    return grade;
}

#pragma UserInfomation
- (NSArray *)userCouponList:(NSArray *)goodslistJSON;
{
    NSMutableArray *products=[NSMutableArray arrayWithCapacity:goodslistJSON.count];
    
    for (NSDictionary *goodsJson in goodslistJSON)
        [products addObject:[self coupon:goodsJson]];
    
    return products;
}
- (COLLECT_GOODS *)coupon:(NSDictionary *)JSON
{
    COLLECT_GOODS *goods = [[COLLECT_GOODS alloc] init];
    goods.name=[JSON objectForKey:@"title"];
    goods.shop_name=[JSON objectForKey:@"man_price"];
    goods.sub_title1=[JSON objectForKey:@"title"];
    goods.sub_title2=[JSON objectForKey:@"etime"];
    //    goods.goods_id=[JSON objectForKey:@"item_id"];
    goods.shop_price= [JSON objectForKey:@"price"];
    goods.rec_id=[JSON objectForKey:@"id"];
    goods.img.small=[JSON objectForKey:@"img"];
    return goods;
}



#pragma UserInfomation
- (NSArray *)userInformationList:(NSArray *)goodslistJSON;
{
    NSMutableArray *products=[NSMutableArray arrayWithCapacity:goodslistJSON.count];
    
    for (NSDictionary *goodsJson in goodslistJSON)
        [products addObject:[self infomation:goodsJson]];
    
    return products;
}
- (COLLECT_GOODS *)infomation:(NSDictionary *)JSON
{
    COLLECT_GOODS *goods = [[COLLECT_GOODS alloc] init];
    goods.name=[JSON objectForKey:@"info"];
    goods.shop_name=[JSON objectForKey:@"title"];
    goods.sub_title1=[JSON objectForKey:@"title"];
    goods.sub_title2=[JSON objectForKey:@"add_time"];
//    goods.goods_id=[JSON objectForKey:@"follow_uid"];
    //    goods.shop_price= [item objectForKey:@"price"];
    goods.rec_id=[JSON objectForKey:@"id"];
    goods.img.small=[JSON objectForKey:@"img"];
    return goods;
}


#pragma UserLike
- (NSArray *)userFavGoodsList:(NSArray *)goodslistJSON;
{
    NSMutableArray *products=[NSMutableArray arrayWithCapacity:goodslistJSON.count];
    
    for (NSDictionary *goodsJson in goodslistJSON)
        [products addObject:[self favGoods:goodsJson]];
    
    return products;
}
- (COLLECT_GOODS *)favGoods:(NSDictionary *)JSON
{
    COLLECT_GOODS *goods = [[COLLECT_GOODS alloc] init];
    goods.name=[JSON objectForKey:@"mname"];
    goods.shop_name=[JSON objectForKey:@"shop_title"];
    goods.sub_title1=[JSON objectForKey:@"pname"];
    goods.sub_title2=[JSON objectForKey:@"address"];
    goods.shop_id=[JSON objectForKey:@"follow_uid"];
//    goods.shop_price= [item objectForKey:@"price"];
    goods.rec_id=[JSON objectForKey:@"id"];
    goods.img.small=[JSON objectForKey:@"img"];
    return goods;
}


#pragma UserAddress
-(NSArray *)listAddresses:(NSArray *)addressesJSON
{
    NSMutableArray *addresses;
    addresses = [NSMutableArray arrayWithCapacity:addressesJSON.count];
    
    for (NSDictionary *adressJson in addressesJSON)
        [addresses addObject:[self address:adressJson]];
    return addresses;
}
- (ADDRESS *)address:(NSDictionary *)addressJSON;
{
    //   NSString *price, *marketPrice;
    ADDRESS *address = [[ADDRESS alloc] init];
    address.rec_id=[addressJSON objectForKey:@"id"];
    address.city_name=[addressJSON objectForKey:@"city"];
//    address.state=[addressJSON objectForKey:@"country"];
    address.city = [addressJSON objectForKey:@"city_id"];
    address.province_name=[addressJSON objectForKey:@"province"];
    address.province = [addressJSON objectForKey:@"province_id"];
    address.district_name=[addressJSON objectForKey:@"area"];
    address.district = [addressJSON objectForKey:@"area_id"];
    address.address=[addressJSON objectForKey:@"address"];
    address.consignee=[addressJSON objectForKey:@"name"];
    address.tel=[addressJSON objectForKey:@"tele"];
    address.zipcode=[addressJSON objectForKey:@"zipcode"];
    address.default_address=[addressJSON objectForKey:@"is_default"];
    
    //    price = [self digitalWithString:[productJSON objectForKey:@"shop_price"]];
    //    marketPrice = [self digitalWithString:
    //                   [productJSON objectForKey:@"market_price"]];
    //
    //    product.productID = [[productJSON objectForKey:@"goods_id"] intValue];
    //    product.name = [productJSON objectForKey:@"name"];
    //    product.listingPrice = [NSDecimalNumber decimalNumberWithString:price];
    //    product.regularPrice = [NSDecimalNumber decimalNumberWithString:marketPrice];
    //
    //    ProductImageURL *productImage;
    //    productImage = [self productImageURL:[productJSON objectForKey:@"img"]];
    //    product.image = productImage;
    
    return address;
}


#pragma UserLike
- (NSArray *)userLikeGoodsList:(NSArray *)goodslistJSON;
{
    NSMutableArray *products=[NSMutableArray arrayWithCapacity:goodslistJSON.count];
    
    for (NSDictionary *goodsJson in goodslistJSON)
        [products addObject:[self collectGoods:goodsJson]];
    
    return products;
}
- (COLLECT_GOODS *)collectGoods:(NSDictionary *)JSON
{
    COLLECT_GOODS *goods = [[COLLECT_GOODS alloc] init];
    NSDictionary *item=[JSON objectForKey:@"item"];
    if (item.count>0) {
        goods.name=[item objectForKey:@"title"];
        goods.shop_price= [item objectForKey:@"price"];
        goods.img.small=[item objectForKey:@"img"];
//        goods.brief=[item objectForKey:@"img"];

    }
    
    goods.goods_id=[JSON objectForKey:@"item_id"];
    goods.rec_id=[JSON objectForKey:@"id"];
    
    return goods;
}


#pragma UserLogin
- (AccessToken *)accessToken:(NSDictionary *)anTokenJson;
{
    AccessToken *accessToken=nil;
    if (anTokenJson!=nil) {
        accessToken = [[AccessToken alloc] init];
        accessToken.accessToken=[anTokenJson objectForKey:@"token"];
        accessToken.userid=[anTokenJson objectForKey:@"id"];
    }
    
    return accessToken;
}

- (USER *)user:(NSDictionary *)anUser;
{
    NSLog(@"%@",anUser);
    USER *user=nil;
    if (anUser!=nil) {
        user = [[USER alloc] init];
        user.email = [anUser objectForKey:@"email"];
        user.tele=[anUser objectForKey:@"tele"];
        user.name = [anUser objectForKey:@"username"];
        user.sex= [anUser objectForKey:@"sex"];
        user.birthday= [anUser objectForKey:@"birthday"];
        user.intro= [anUser objectForKey:@"intro"];
        user.avatarimg= [anUser objectForKey:@"img"];
        user.msg_express= [anUser objectForKey:@"msg_express"];
        user.msg_sales= [anUser objectForKey:@"msg_sales"];
        user.msg_sys= [anUser objectForKey:@"msg_sys"];
        user.order_fahuo= [anUser objectForKey:@"order_fahuo"];
        user.order_fukuan= [anUser objectForKey:@"order_fukuan"];
        user.order_shouhuo= [anUser objectForKey:@"order_shouhuo"];
        user.coupon_num= [anUser objectForKey:@"quan"];
        user.score= [anUser objectForKey:@"score"];
        user.user_id = [anUser objectForKey:@"id"];
        user.token=[anUser objectForKey:@"token"];
        user.rank_level=[anUser objectForKey:@"level"];
        user.weibo=[anUser objectForKey:@"weibo"];
        user.weixin=[anUser objectForKey:@"weixin"];
        user.qq=[anUser objectForKey:@"qq"];
        user.coupon_num=[anUser objectForKey:@"quans"];
        user.provence=[anUser objectForKey:@"province"];
        user.city=[anUser objectForKey:@"city"];
        user.area=[anUser objectForKey:@"area"];
        user.likeNum = [[anUser objectForKey:@"likes"] description];
        user.attentionNum = [[anUser objectForKey:@"favs"] description];
    }
    
    return user;
}

@end
