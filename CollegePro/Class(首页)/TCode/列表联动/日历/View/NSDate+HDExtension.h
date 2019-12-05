//
//  NSDate+HDExtension.h
//  FMDB
//
//  Created by 黄定师 on 2018/12/11.
//  Copyright © 2018 黄定师. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HDExtension)

+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;

@end

NS_ASSUME_NONNULL_END
