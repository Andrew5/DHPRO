//
//  QDExceptionHandler.h
//  UncaughtExceptionHandler
//
//  Created by jabraknight on 19/9/20.
//  Copyright © 2019年 Cocoa with Love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QDExceptionHandler : NSObject
void InstallSignalHandler(void);

void InstallUncaughtExceptionHandler(void);
void UncaughtExceptionHandler(NSException *exception);

@end
