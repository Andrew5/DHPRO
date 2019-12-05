//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderAssembler.h"
#import "OrderManager.h"
@implementation OrderAssembler
-(NSArray *)ordersWithJSON:(NSArray *)JSON index:(NSNumber*)index
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON){
        [items addObject:[self orderWithJSON:item]];
    }
    switch ([index integerValue]) {
        case 0:
            [OrderManager shareOrederManager].orderNum = items.count;
            break;
        case 1:
            [OrderManager shareOrederManager].sendNum = items.count;
            break;
        case 2:
            [OrderManager shareOrederManager].recerveNum = items.count;
            break;
        case 3:
            [OrderManager shareOrederManager].refundNum = items.count;
            break;

            
        default:
            break;
    }
    [OrderManager saveData];
    return items;
}
-(ORDER *)orderWithJSON:(NSDictionary *)JSON
{
    ORDER *od=[[ORDER alloc] init];
    od.rec_id=[JSON objectForKey:@"id"];
    od.order_info.order_id=[JSON objectForKey:@"orderid"];
    od.order_info.order_time=[JSON objectForKey:@"add_time"];
    od.order_info.pay_time=[JSON objectForKey:@"pays_time"];
    od.order_info.check_time=[JSON objectForKey:@"check_time"];
    od.formated_shipping_fee=[JSON objectForKey:@"express"];
    od.order_info.order_id=[JSON objectForKey:@"orderid"];
    od.order_info.pay_code=[JSON objectForKey:@"pays_sn"];
    od.order_info.total_fee=[JSON objectForKey:@"total"];
    od.order_info.order_status=[JSON objectForKey:@"status"];
    
    od.order_info.order_sstatus=[self getOrderSStatus:[NSString stringWithFormat:@"%ld",[od.order_info.order_status integerValue]]];
    
    od.shop_item=[self shopItem:[JSON objectForKey:@"items"]];
    od.shop_item.name=[JSON objectForKey:@"shop_title"];
    
    od.address_item.address=[JSON objectForKey:@"addr_address"];
    od.address_item.province_name=[JSON objectForKey:@"addr_province"];
    od.address_item.city_name=[JSON objectForKey:@"addr_city"];
    od.address_item.district_name=[JSON objectForKey:@"addr_area"];
    od.address_item.consignee=[JSON objectForKey:@"addr_name"];
    od.address_item.zipcode=[JSON objectForKey:@"addr_zipcode"];
    
    od.shipping_item.shipping_desc=[JSON objectForKey:@"express_remark"];
    od.shipping_item.shipping_code=[JSON objectForKey:@"express_code"];
    od.shipping_item.shipping_sn=[JSON objectForKey:@"express_sn"];
    od.shipping_item.shipping_name=[JSON objectForKey:@"express_name"];
    od.shipping_item.shipping_time=[JSON objectForKey:@"express_time"];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    od.shipping_item.shipping_time=currentDateStr;
    return od;
}
-(NSString *)getOrderSStatus:(NSString *)status
{
    if ([status isEqualToString:@"0"]) {
        return @"待付款";
    }
    else if ([status isEqualToString:@"1"]) {
        return @"待发货";
    }
    else if ([status isEqualToString:@"2"]) {
        return @"待收货";
    }
    else if ([status isEqualToString:@"5"]) {
        return @"已关闭";
    }
    else if ([status isEqualToString:@"4"]) {
        return @"已完成";
    }
    return @"未知类型";
}
-(NSArray *)shopItemsWithJSON:(NSArray *)JSON
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self shopItem:item]];
    return items;
}
-(SHOP_ITEM *)shopItem:(NSDictionary *)Json
{
    SHOP_ITEM *item=[SHOP_ITEM new];
    item.cart_goods_list=[self cartGoodsList:Json];
    return item;
}
-(NSMutableArray *)cartGoodsList:(NSArray *)JSON
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self cartGoods:item]];
    return items;
}
-(CART_GOODS *)cartGoods:(NSDictionary *)Json
{
    CART_GOODS *cd=[CART_GOODS new];
    @try{
        cd.goods_name=[Json objectForKey:@"item_title"];
        cd.img.small=[Json objectForKey:@"item_img"];
        cd.goods_price=[[Json objectForKey:@"item_price"] floatValue];
        cd.goods_number=[[Json objectForKey:@"num"] integerValue];
        cd.goods_strattr=[Json objectForKey:@"attr"];
    }@catch(NSException *e){}
    return cd;
}
@end
