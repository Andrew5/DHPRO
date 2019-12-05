//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsAssembler.h"

@implementation GoodsAssembler
- (GOODS_DETAIL_INFO *)goodsDetailsWithJSON:(NSDictionary *)JSON {
    GOODS_DETAIL_INFO *gdi = [GOODS_DETAIL_INFO new];
    gdi.item_info = [self goodsDetailListWithJSON:JSON[@"item_info"] withType:0];
    gdi.producer = [self goodsDetailListWithJSON:JSON[@"producer"] withType:0];
    gdi.score = [self goodsDetailListWithJSON:JSON[@"score"] withType:3];
    gdi.logs_info_list = [[JSON[@"logs_list"] objectForKey:@"info_list"] objectForKey:@"info_array"];
  
    gdi.logs_list = [[JSON[@"logs_list"] objectForKey:@"list"] objectForKey:@"info_array"];

    return gdi;
}

- (NSArray *)goodsDetailListWithJSON:(id)JSON withType:(NSInteger)type {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
  
    if ([JSON isKindOfClass:[NSDictionary class]]) {
        [items addObject:[self goodDetailWithJSON:JSON withType:type]];
    }else
    {
        for (NSDictionary *item in JSON) {
            if (item) {
                if ([item[@"name"] isEqualToString:@""]) {
                    continue;
                }
                [items addObject:[self goodDetailWithJSON:item withType:type]];
            }
        }
    }
   
    return items;
}

#pragma mark -
- (CATEGORY *)goodDetailWithJSON:(NSDictionary *)JSON withType:(NSInteger)type {
    CATEGORY *goodattr = [[CATEGORY alloc] init];
//    NSLog(@"%@",JSON);
        goodattr.type = JSON[@"type"];
        if (type == 1) {
            goodattr.name = JSON[@"name"];
            goodattr.value = JSON[@"info"];
        }
        else if (type == 2) {
            goodattr.name = JSON[@"name"];
            goodattr.value = JSON[@"info"];
            goodattr.add_time = JSON[@"add_time"];
        }
        else {
            NSMutableArray *children;
            if ([JSON[@"info_array"] isKindOfClass:[NSArray class]]) {
                NSArray *childrenJSON = JSON[@"info_array"];
                if (childrenJSON && childrenJSON.count > 0) {
                    children = [[NSMutableArray alloc] initWithCapacity:childrenJSON.count];
                    for (NSDictionary *childJSON in childrenJSON)
                        [children addObject:[self goodDetailWithJSON:childJSON withType:type]];
                    goodattr.children = children;
                }
            }
            
            if (type == 3 && [JSON[@"html"] isKindOfClass:[NSString class]] && ![JSON[@"html"] isEqualToString:@""]) {
                goodattr.rich_value = @"<font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>Text with</font> <font face=AmericanTypewriter size=16 color=purple>different colours</font> <font face=Futura size=32 color='#dd1100'>and sizes</font>";
            }
            
            goodattr.name = JSON[@"name"];
            goodattr.value = JSON[@"info"];
            goodattr.img.small = JSON[@"img"];
        }
        
        
        return goodattr;

    
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

- (NSArray *)goodsListWithJSON:(NSArray *)JSON; {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self collectGoodsWithJSON:item]];
    return items;
}

- (COLLECT_GOODS *)collectGoodsWithJSON:(NSDictionary *)JSON {
    COLLECT_GOODS *goods = [[COLLECT_GOODS alloc] init];
    goods.name = [JSON objectForKey:@"title"];
    goods.shop_name = [JSON objectForKey:@"shop_title"];
    goods.sub_title1 = [JSON objectForKey:@"sales"];
    goods.sub_title2 = [JSON objectForKey:@"address"];
    goods.shop_price = [JSON objectForKey:@"price"];
    goods.goods_id = [JSON objectForKey:@"id"];
    //    goods.shop_price= [item objectForKey:@"price"];
    goods.rec_id = [JSON objectForKey:@"id"];
    goods.img.small = [JSON objectForKey:@"img"];
    return goods;
}

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

- (NSArray *)productImageURLs:(NSArray *)productImageURLJSON {
    NSMutableArray *images;
    images = [NSMutableArray arrayWithCapacity:productImageURLJSON.count];

    for (NSDictionary *productImage in productImageURLJSON) {
        [images addObject:[self productImageURL:productImage]];
    }

    return images;
}

- (PHOTO *)productImageURL:(NSDictionary *)productImageURLJSON {
    PHOTO *p = [PHOTO new];
    p.img = [productImageURLJSON objectForKey:@"img"];
    p.url = [productImageURLJSON objectForKey:@"img"];
    p.thumb = [productImageURLJSON objectForKey:@"img"];
    p.small = [productImageURLJSON objectForKey:@"img"];
    p.small = [productImageURLJSON objectForKey:@"img"];
    p.type = [productImageURLJSON objectForKey:@"type"];
    return p;

}

@end
