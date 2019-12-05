//
//  main.m
//  CollegePro
//
//  Created by jabraknight on 2019/4/30.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DHSendRunObject.h"
CFAbsoluteTime StartTime;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        StartTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

