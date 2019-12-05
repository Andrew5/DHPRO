//
//  XFAssetsLibraryData.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/6.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;

@interface XFAssetsLibraryData : NSObject

+ (void)getLibraryGroupWithSuccess:(void (^)(NSArray *array))successBlock
                         failBlcok:(void (^)(NSError *error))failBlock;

+ (void)getAssetsWithGroup:(ALAssetsGroup *)group successBlock:(void (^)(NSArray *array))successBlock;

@end
