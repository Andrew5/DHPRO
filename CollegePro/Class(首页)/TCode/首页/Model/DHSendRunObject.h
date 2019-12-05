//
//  DHSendRunObject.h
//  CollegePro
//
//  Created by jabraknight on 2019/5/29.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHSendRunObject : UIApplication
@property (nonatomic, strong) NSTimer *Timer;

-(void)resetTimer;

@end

NS_ASSUME_NONNULL_END
