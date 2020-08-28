//
//  NSDate+HDExtension.m
//  FMDB
//
//  Created by 黄定师 on 2018/12/11.
//  Copyright © 2018 黄定师. All rights reserved.
//

#import "NSDate+HDExtension.h"

@implementation NSDate (HDExtension)

#pragma mark - 获取某年某月的天数
+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    if ((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12)) {
        return 31 ;
    }
    
    if ((month == 4) || (month == 6) || (month == 9) || (month == 11)) {
        return 30;
    }
    
    if ((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)) {
        return 28;
    }
    
    if (year % 400 == 0) {
        return 29;
    }
    
    if (year % 100 == 0) {
        return 28;
    }
    
    return 29;
}

@end
