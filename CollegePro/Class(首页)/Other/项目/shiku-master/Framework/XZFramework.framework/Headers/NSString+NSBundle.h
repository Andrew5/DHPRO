//
//  NSString+NSBundle.h
//  btc
//
//  Created by txj on 15/1/28.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSBundle)

- (BOOL)isBundlePath;
- (NSURL *)urlForBundle;
- (NSString *)pathForBundle;
@end


