//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CartAssembler.h"
#import "Cart.h"
@implementation CartAssembler


-(NSArray *)shopItemsWithJSON:(NSArray *)JSON
{
    if (JSON.count==0) {
        [Cart shared].Num=0;
        [Cart saveCartNum];
    }
    [Cart shared].Num = 0;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self shopItem:item]];

    return items;
}

-(SHOP_ITEM *)shopItem:(NSDictionary *)Json
{
    SHOP_ITEM *item=[SHOP_ITEM new];
    item.rec_id=[Json objectForKey:@"mid"];
    item.name=[Json objectForKey:@"mname"];
    item.cart_goods_list=[self cartGoodsList:[Json objectForKey:@"item_list"]];
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
    cd.rec_id=[Json objectForKey:@"id"];
    cd.goods_id=[Json objectForKey:@"item_id"];
    cd.goods_strattr=[Json objectForKey:@"attr"];
    cd.goods_name=[Json objectForKey:@"item_title"];
    cd.img.small=[Json objectForKey:@"item_img"];
    cd.goods_weight=[[Json objectForKey:@"attr"] floatValue];
    cd.goods_price=[[Json objectForKey:@"price"] floatValue];
    cd.goods_number=[[Json objectForKey:@"num"] integerValue];
    [Cart AddNumWithGoodsNum:cd.goods_number];
    return cd;
}
@end
