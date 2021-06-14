//
//  CLLocationManager+Doraemon.h
//  DoraemonKit-DoraemonKit
//
//  Created by yixiang on 2021/1/2.
//

#import <CoreLocation/CoreLocation.h>

//参考wander
@interface CLLocationManager (Doraemon)

- (void)doraemon_swizzleLocationDelegate:(id)delegate;

@end
