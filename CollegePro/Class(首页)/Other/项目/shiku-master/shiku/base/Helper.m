//
//  Helper.m
//  shiku
//
//  Created by  on 15/9/24.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString*)checkImgType:(NSString*)imgUrl
{
    NSString *url = [NSString string];
    if ([imgUrl containsString:@".jpg"]) {
        url = [imgUrl stringByReplacingOccurrencesOfString:@".jpg" withString:@"_middle.jpg"];
    }
    else if ([imgUrl containsString:@".JPG"]) {
        url = [imgUrl stringByReplacingOccurrencesOfString:@".JPG" withString:@"_middle.JPG"];
    }
    else if ([imgUrl containsString:@".png"]) {
        url = [imgUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_middle.png"];
    } else if ([imgUrl containsString:@".gif"]) {
        url = [imgUrl stringByReplacingOccurrencesOfString:@".gif" withString:@"_middle.gif"];
    }
    
    return url;
}

@end
