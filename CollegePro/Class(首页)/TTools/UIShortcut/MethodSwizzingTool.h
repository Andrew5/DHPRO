//
//  MethodSwizzingTool.h
//  OneKeyAnalysis
//
//  Created by Rillakkuma on 2021/1/2.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodSwizzingTool : NSObject


+(void)swizzingForClass:(Class)cls originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector;


+(NSDictionary *)getConfig;

@end
