//
//  NSDictionary+Safe.m
//  CollegePro
//
//  Created by jabraknight on 2019/12/21.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSDictionary (Safe)
+ (void)load{
    [super load];
    [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setObject:forKey:)
                                 withSwizzledSelector:@selector(setObjectObject:forKey:)];
}
- (void)setObjectObject:(nullable id)value forKey:(NSString *)defaultName{
    if (value == nil) {
        [self setObjectObject:@"" forKey:defaultName];
    }else{
        [self setObjectObject:value forKey:defaultName];
    }
}

- (NSString *)dictToJson{
    
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];
}
@end
