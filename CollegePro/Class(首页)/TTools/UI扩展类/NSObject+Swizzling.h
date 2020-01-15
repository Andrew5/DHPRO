//
//  NSObject+Swizzling.h
//  DragTableviewCell
//
//  Created by PacteraLF on 16/11/24.
//  Copyright © 2016年 PacteraLF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end
