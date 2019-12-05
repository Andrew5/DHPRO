//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeAssembler.h"

@implementation HomeAssembler
-(HomeItems *)homeItem:(NSDictionary *)JSON
{
    self.goodsAssembler=[[GoodsAssembler alloc] init];
    HomeItems *hitem=[[HomeItems alloc] init];
    hitem.section0List=[self adItems:(NSArray *)[JSON objectForKey:@"ad_list"]];
    hitem.section1List=[self adItems:(NSArray *)[JSON objectForKey:@"ad_list2"]];
    hitem.section2List=[self adItems:(NSArray *)[JSON objectForKey:@"ad_list3"]];
    hitem.section3List=[self adItems:(NSArray *)[JSON objectForKey:@"ad_list4"]];
    hitem.section4List=[self adItems:(NSArray *)[JSON objectForKey:@"ad_list5"]];
    hitem.section5List=[self.goodsAssembler goodsListWithJSON:(NSArray *)[JSON objectForKey:@"hots_item_list"]];
    
    return hitem;
}
//////////滚动图片解析/////////////////
- (NSArray *)adItems:(NSArray *)itemsJSON
{
    NSMutableArray *items;
    items = [NSMutableArray arrayWithCapacity:itemsJSON.count];
    
    for (NSDictionary *item in itemsJSON)
        [items addObject:[self adItem:item]];
    
    return items;
}

-(AdItem *)adItem:(NSDictionary *)JSON
{
    AdItem *ad=[[AdItem alloc] init];
    ad.actiontype=[JSON objectForKey:@"adclicktype"];
    ad.adTypeInt=[JSON objectForKey:@"type"];
    ad.productId=[JSON objectForKey:@"productid"];
    ad.categoryId=[JSON objectForKey:@"cateid"];
    ad.html=[JSON objectForKey:@"html"];
    ad.keyWords=[JSON objectForKey:@"keywords"];
    ad.title=[JSON objectForKey:@"name"];
    ad.url=[JSON objectForKey:@"img"];
    ad.desc=[JSON objectForKey:@"desc"];
    ad.startTime=[JSON objectForKey:@"start_time"];
    ad.endTime=[JSON objectForKey:@"end_time"];
    ad.price=[JSON objectForKey:@"price"];
    return ad;
}
@end
