//
//  KeyBoardModel.h
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyBoardModel : NSObject
@property (nonatomic,copy) NSString * key;

@property (nonatomic,assign) BOOL isUpper;
@end

NS_ASSUME_NONNULL_END
