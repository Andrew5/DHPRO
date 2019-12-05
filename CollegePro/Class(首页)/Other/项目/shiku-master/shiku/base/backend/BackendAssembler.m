//
//  BackendAssembler.m
//  btc
//
//  Created by txj on 15/1/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "BackendAssembler.h"

@implementation BackendAssembler
- (NSError *)error:(NSDictionary *)JSON
{
    NSError *error;
    
    if ([[JSON valueForKeyPath:@"status"] integerValue] == 0) {
        NSInteger errorCode;
        NSDictionary *errorDescription;
        errorCode = 001;
        errorDescription = @{
                             NSLocalizedDescriptionKey:
                                 [JSON valueForKeyPath:@"result"]
                             };
        error = [NSError errorWithDomain:@"CMMobile" code:errorCode
                                userInfo:errorDescription];
    }
    
    return error;
}

- (NSString *)digitalWithString:(NSString *)string
{
    NSString *pattern = @"([\\d\\.]+)";
    NSError *error;
    NSRegularExpression *expression;
    if (!string || nil == string || [string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                           options:0
                                                             error:&error];
    NSArray *matches = [expression matchesInString:string
                                           options:0
                                             range:NSMakeRange(0, string.length)
                        ];
    
    for (NSTextCheckingResult *match in matches) {
        return [string substringWithRange:[match range]];
    }
    return nil;
}
-(ResponseResult *)responseResult:(NSDictionary *)responseObject
{
//    NSLog(@"%@",responseObject);
    ResponseResult *rs=[[ResponseResult alloc] init];
    
    rs.success=[[responseObject objectForKey:@"status"] boolValue];
    rs.messge=[[responseObject objectForKey:@"result"] description];
    rs.data=[responseObject objectForKey:@"data"];
    rs.strdata=[[responseObject objectForKey:@"data"] description];
    
    return rs;
}
-(PAGINATION *)pagination:(NSDictionary *)pageInfo
{
    PAGINATION *p=[PAGINATION new];
    p.page=[pageInfo objectForKey:@"page"];
    p.count=[pageInfo objectForKey:@"perPage"];
//    p.count=[[NSNumber alloc] initWithInt:200];
    p.total=[pageInfo objectForKey:@"totalPage"];
//    p.more=[pageInfo objectForKey:@"more"];
    p.more=p.page<p.total;
    return p;
}
-(NSMutableDictionary *)paginationToJsonObject:(PAGINATION *)pagination
{
    NSMutableDictionary *jo = [[NSMutableDictionary alloc] init];
    [jo setValue:pagination.page forKey:@"page"];
    [jo setValue:pagination.count forKey:@"perPage"];
    [jo setValue:pagination.total forKey:@"totalPage"];
    return jo;
}
@end
