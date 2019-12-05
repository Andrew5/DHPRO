//
//  HomeNewAssembler.m
//  shiku
//
//  Created by  on 15/9/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeNewAssembler.h"

@implementation HomeNewAssembler
- (GOODS *)goodsWithJSON:(NSDictionary *)JSON {
    GOODS *goods = [[GOODS alloc] init];
    goods.rec_id = JSON[@"id"];
    goods.goods_id = JSON[@"id"];
    
    //    NSLog(@"数据%@",goods.pictures = JSON[@"item_img"]);
    //    NSDictionary *dict =goods.pictures[0];
    //    if ([dict[@"type"] isEqualToString:@"2"]) {
    //        NSLog(@"-=%@",dict[@"img"]);
    //    }
    //    NSLog(@"type %@",dict[@"type"]);
    //    NSLog(@"img %@",dict[@"img"]);
    
    
    goods.pictures = JSON[@"item_img"];
    //    goods.pictures = [self productImageURLs:JSON[@"item_img"]];
    goods.goods_name = JSON[@"title"];
    goods.shop_price = JSON[@"price"];
    goods.market_price = JSON[@"rprice"];
    goods.goods_attr = [self cateListWithJSON:JSON[@"sku_list"]];
    goods.good_stocks = JSON[@"stock"];
    goods.img.small = JSON[@"img"];
    goods.collected = JSON[@"is_like"];
    goods.collected_count = JSON[@"likes"];
    goods.sales = JSON[@"sales"];
    goods.shop_address = [JSON[@"member_shop"] objectForKey:@"address"];
    goods.shop_collected = [JSON[@"member_shop"] objectForKey:@"is_follow"];
    goods.shop_collected_count = [JSON[@"member_shop"] objectForKey:@"follows"];
    goods.shop_uname = [JSON[@"member_shop"] objectForKey:@"uname"];
    goods.shop_img.small = [JSON[@"member_shop"] objectForKey:@"img"];
    goods.shop_rates = [JSON[@"member_shop"] objectForKey:@"rates"];
    goods.shop_name = [JSON[@"member_shop"] objectForKey:@"title"];
    goods.shop_item_count = [JSON[@"member_shop"] objectForKey:@"item_count"];
    goods.shop_item_stock = [JSON[@"member_shop"] objectForKey:@"item_stock"];
    goods.shop_id = [JSON[@"member_shop"] objectForKey:@"mid"];
    return goods;
    
}
- (NSArray *)cateListWithJSON:(NSArray *)JSON; {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if ([JSON isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in JSON)
            [items addObject:[self cateWithJSON:item]];
        
    }
    return items;
}
- (CATEGORY *)cateWithJSON:(NSDictionary *)JSON {
    CATEGORY *cate = [[CATEGORY alloc] init];
    
    cate.name = [JSON objectForKey:@"name"];
    cate.value = [JSON objectForKey:@"nums"];
    return cate;
}
@end
