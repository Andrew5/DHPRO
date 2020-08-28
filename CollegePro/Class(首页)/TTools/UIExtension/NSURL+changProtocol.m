//
//  NSURL+changProtocol.m
//  JHUniversalApp
//
//  Created by jhwhz on 2016/12/19.
//  Copyright © 2016年  William Sterling. All rights reserved.
//

#import "NSURL+changProtocol.h"

@implementation NSURL (changProtocol)


+ (instancetype)changProtocolURLWithString:(NSString *)URLString
{
    if (URLString ==nil || [URLString isEqualToString:@""] || URLString.length == 0) {
        
        return [[NSURL alloc] init];
    }
    
    NSMutableArray *urlArray = [NSMutableArray arrayWithArray:[URLString componentsSeparatedByString:@"://"]];
    if (urlArray.count > 0) {
        NSString *strProtocol = [NSString stringWithFormat:@"%@",[urlArray firstObject]];
        if ([strProtocol isEqualToString:@"http"]) {
            [urlArray replaceObjectAtIndex:0 withObject:@"https"];
        }
    }
    URLString = [urlArray componentsJoinedByString:@"://"];
    
    return [NSURL URLWithString:URLString];
}
@end
