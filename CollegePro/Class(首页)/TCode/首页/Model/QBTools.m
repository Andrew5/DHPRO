//
//  QBTools.m
//  
//
//  Created by tanglh on 19/5/15.
//  Copyright (c) 2015 MD313. All rights reserved.
//

#import "QBTools.h"
//#import "UMOnlineConfig.h"

@implementation QBTools

+ (NSString *)formattedBandWidth:(unsigned long long)size
{
    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0 KB",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qubytes", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        formattedStr = [NSString stringWithFormat:@"%quKB", (size / 1024)];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        int intsize = size / pow(1024, 2);
        formattedStr = [NSString stringWithFormat:@"%dMB", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dGB", intsize];
    }
    
    return formattedStr;
}
+ (int)formatBandWidthInt:(unsigned long long) size{
    
    size *= 8;
    int intsize = 0;
    if (size >= pow(1024, 2) && size < pow(1024, 3)){
        intsize = size / pow(1024, 2);
        unsigned long long l = pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
    }
    return intsize;
}

+ (NSString *)formatBandWidth:(unsigned long long)size
{
    size *=8;

    NSString *formattedStr = nil;
    if (size == 0){
        formattedStr = NSLocalizedString(@"0",@"");
        
    }else if (size > 0 && size < 1024){
        formattedStr = [NSString stringWithFormat:@"%qu", size];
        
    }else if (size >= 1024 && size < pow(1024, 2)){
        int intsize = (int)(size / 1024);
        int model = size % 1024;
        if (model > 512) {
            intsize += 1;
        }
        
        formattedStr = [NSString stringWithFormat:@"%dK",intsize ];
        
    }else if (size >= pow(1024, 2) && size < pow(1024, 3)){
        unsigned long long l = pow(1024, 2);
        int intsize = size / pow(1024, 2);
        int  model = (int)(size % l);
        if (model > l/2) {
            intsize +=1;
        }
        formattedStr = [NSString stringWithFormat:@"%dM", intsize];
        
    }else if (size >= pow(1024, 3)){
        int intsize = size / pow(1024, 3);
        formattedStr = [NSString stringWithFormat:@"%dG", intsize];
    }
    
    return formattedStr;
}

+ (NSString *)formattedFileSize:(unsigned long long)size
{
    return [self formattedFileSize:size suffixLenth:NULL];
}

+ (NSString *)formattedFileSize:(unsigned long long)size suffixLenth:(NSInteger )length
{
    NSInteger len = 0;
    NSString *formattedStr = nil;
    if (size == 0)
        formattedStr = NSLocalizedString(@"0 KB",@""), len = 2;
    else
        if (size > 0 && size < 1024)
            formattedStr = [NSString stringWithFormat:@"%qubytes", size], length = 2, len = 7;
        else
            if (size >= 1024 && size < pow(1024, 2))
                formattedStr = [NSString stringWithFormat:@"%.2fKB", (size / 1024.)], len = 2;
            else
                if (size >= pow(1024, 2) && size < pow(1024, 3))
                    formattedStr = [NSString stringWithFormat:@"%.2fMB", (size / pow(1024, 2))], len = 2;
                else
                    if (size >= pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2fGB", (size / pow(1024, 3))], len = 2;
    if (length) {
        length = len;
    }
    return formattedStr;
}

+ (unsigned long long) antiFormatBandWith:(NSString *)sizeStr
{
    unsigned long long fileSize = 0;
    if(![sizeStr isEqualToString:NSLocalizedString(@"0 KB",@"")]){
        if([sizeStr hasSuffix:@"bytes"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"bytes"] objectAtIndex:0] longLongValue];
        else if([sizeStr hasSuffix:@"KB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"KB"] objectAtIndex:0] floatValue] * 1024;
        else if([sizeStr hasSuffix:@"MB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"MB"] objectAtIndex:0] floatValue] * pow(1024, 2);
        else if([sizeStr hasSuffix:@"GB"])
            fileSize = [[[sizeStr componentsSeparatedByString:@"GB"] objectAtIndex:0] floatValue] * pow(1024, 3);
    }
    
    return fileSize;
}

@end
