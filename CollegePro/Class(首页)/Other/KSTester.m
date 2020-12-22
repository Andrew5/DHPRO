//
//  KSTester.m
//  KSTestApp
//
//  Created by kesalin on 30/4/13.
//  Copyright (c) 2013 kesalin@gmail.com. All rights reserved.
//

#import "KSTester.h"

#define KSLog(format, ...) CFShow((__bridge CFTypeRef)[NSString stringWithFormat:format, ## __VA_ARGS__]);

@implementation KSTester

typedef NSString* (^IntToStringConverter)(id self, NSInteger paramInteger);
- (NSString *) convertIntToString:(NSInteger)paramInteger
                 usingBlockObject:(IntToStringConverter)paramBlockObject
{
    return paramBlockObject(self, paramInteger);
}

typedef NSString* (^IntToStringInlineConverter)(NSInteger paramInteger);
- (NSString *) convertIntToStringInline:(NSInteger)paramInteger
                 usingBlockObject:(IntToStringInlineConverter)paramBlockObject
{
    return paramBlockObject(paramInteger);
}

IntToStringConverter independentBlockObject = ^(id self, NSInteger paramInteger) {
    KSLog(@" >> self %@, memberVariable %ld", self, (long)[self memberVariable]);
    
    NSString *result = [NSString stringWithFormat:@"%ld", (long)paramInteger];
    KSLog(@" >> independentBlockObject %@", result);
    return result;
};

- (void)testAccessSelf
{
    // Independent
    //
    [self convertIntToString:20 usingBlockObject:independentBlockObject];
    
    // Inline
    //
    IntToStringInlineConverter inlineBlockObject = ^(NSInteger paramInteger) {
        KSLog(@" >> self %@, memberVariable %ld", self, (long)self.memberVariable);
        
        NSString *result = [NSString stringWithFormat:@"%ld", (long)paramInteger];
        KSLog(@" >> inlineBlockObject %@", result);
        return result;
    };
    [self convertIntToStringInline:20 usingBlockObject:inlineBlockObject];
}

- (void)testAccessVariable
{
    //NSInteger outsideVariable = 10;
    __block NSInteger outsideVariable = 10;
    NSMutableArray * outsideArray = [[NSMutableArray alloc] init];
    
    void (^blockObject)(void) = ^(void){
        NSInteger insideVariable = 20;
        KSLog(@"  > member variable = %ld", (long)self.memberVariable);
        KSLog(@"  > outside variable = %ld", (long)outsideVariable);
        KSLog(@"  > inside variable = %ld", (long)insideVariable);
        
        [outsideArray addObject:@"AddedInsideBlock"];
    };
    
    outsideVariable = 30;
    self.memberVariable = 30;

    blockObject();
    
    KSLog(@"  > %lu items in outsideArray", (unsigned long)[outsideArray count]);
}

- (id) getBlockArray
{
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{ KSLog(@"  > block 0:%d", val); },    // block on the stack
            ^{ KSLog(@"  > block 1:%d", val); },    // block on the stack
            nil];
    
//    return [[NSArray alloc] initWithObjects:
//            [^{ KSLog(@"  > block 0:%d", val); } copy],    // block copy to heap
//            [^{ KSLog(@"  > block 1:%d", val); } copy],    // block copy to heap
//            nil];
}

- (void)testManageBlockMemory
{
    id obj = [self getBlockArray];
    typedef void (^BlockType)(void);
    BlockType blockObject = (BlockType)[obj objectAtIndex:0];
    blockObject();
}

- (void)run
{
    KSLog(@" >> KSTester running...");
    
    self.memberVariable = 10;
    
    //[self testAccessVariable];
    
    //[self testAccessSelf];
    
    [self testManageBlockMemory];
    
    KSLog(@" >> KSTester exit");
}

@end
