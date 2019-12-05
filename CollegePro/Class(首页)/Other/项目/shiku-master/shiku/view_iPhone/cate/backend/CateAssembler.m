//
//  OrderAssembler.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CateAssembler.h"

@implementation CateAssembler
-(NSArray *)cateListWithJSON:(NSArray *)JSON;
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON)
        [items addObject:[self cateWithJSON:item]];
    return items;
}
-(CATEGORY *)cateWithJSON:(NSDictionary *)JSON
{
    CATEGORY *cate = [[CATEGORY alloc] init];
    NSMutableArray *children;
    NSArray *childrenJSON = [JSON objectForKey:@"items"];
    if (childrenJSON && childrenJSON.count > 0) {
        children = [[NSMutableArray alloc] initWithCapacity:childrenJSON.count];
        for (NSDictionary *childJSON in childrenJSON)
            [children addObject:[self cateWithJSON:childJSON]];
    }
    cate.rec_id=[JSON objectForKey:@"id"];
    cate.name=[JSON objectForKey:@"name"];
    cate.img.small=[JSON objectForKey:@"img"];
    cate.children = children;
    return cate;
}
@end
