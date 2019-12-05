//
//  CLLocation+Sino.h
//

#import <CoreLocation/CoreLocation.h>

/**
 CLLocation类扩展
 */
@interface CLLocation (Sino)

/**地球坐标转火星坐标*/
- (CLLocation*)locationMarsFromEarth;

/**火星坐标转百度坐标*/
- (CLLocation*)locationBearPawFromMars;

/**百度坐标转火星坐标*/
- (CLLocation*)locationMarsFromBearPaw;

@end