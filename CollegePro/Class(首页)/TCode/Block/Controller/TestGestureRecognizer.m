//
//  TestGestureRecognizer.m
//  wcdb
//
//  Created by jabraknight on 2021/4/29.
//  Copyright © 2021 jabraknight. All rights reserved.
//

#import "TestGestureRecognizer.h"
#import <objc/runtime.h>

@implementation TestGestureRecognizer
- (NSDictionary *)cf_KeysWithValues {
    unsigned int count ,i;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    for (i = 0; i < count; i++) {
        objc_property_t property = propertyArray[i];
        NSString *proKey = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id proValue = [self valueForKey:proKey];

        if (proValue) {
            [dic setObject:proValue forKey:proKey];
        } else {
            [dic setObject:@"" forKey:proKey];
        }
    }
    free(propertyArray);
    return dic;
}

@end
