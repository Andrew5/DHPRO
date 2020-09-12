//
//  NetworkSpeedViewController.h
//  MyFirstOCUseSwiftDemo
//
//  Created by jabraknight on 2020/4/9.
//  Copyright © 2020 jabraknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NetworkSpeedViewController : BaseViewController
@property (nonatomic, copy) void (^instantBlock)(BOOL upSpeed);

@end

NS_ASSUME_NONNULL_END
