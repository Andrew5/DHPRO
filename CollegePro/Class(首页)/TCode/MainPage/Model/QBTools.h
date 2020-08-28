//
//  QBTools.h
//  
//
//  Created by tanglh on 19/5/15.
//  Copyright (c) 2015 MD313. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBTools : NSObject

+ (unsigned long long) antiFormatBandWith:(NSString *)sizeStr;
+ (NSString *)formattedFileSize:(unsigned long long)size;
//suffixLenth 单位字符串长度
+ (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger *)length;
+ (NSString *)formattedBandWidth:(unsigned long long)size;
+ (NSString *)formatBandWidth:(unsigned long long)size;
+ (int)formatBandWidthInt:(unsigned long long) size;

 
@end
