//
//  NSString+Extension.m
//  Test
//
//  Created by Rillakkuma on 2018/2/11.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (NSString *)VerticalString{
	NSMutableString * str = [[NSMutableString alloc] initWithString:self];
	NSInteger count = str.length;
	for (int i = 1; i < count; i ++) {
		[str insertString:@"\n" atIndex:i*2 - 1];
	}
	return str;
}

@end
