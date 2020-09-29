//
//  SBApplication.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/26.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "SBDisplay.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface SBApplication : SBDisplay
-(NSString*)bundleIdentifier;
-(NSString*)path;
-(int)dataUsage;
-(BOOL)isSystemApplication;
-(BOOL)isSystemProvisioningApplication;
-(BOOL)isWidgetApplication;
-(NSString*)displayName;
-(NSString*)longDisplayName;
-(void)markLaunchTime;
-(pid_t)pid;
-(NSString*)launchdJobLabel;
-(NSString*)pathForIcon;
-(NSString*)pathForSmallIcon;
@end

NS_ASSUME_NONNULL_END
