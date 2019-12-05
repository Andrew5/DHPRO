#import <Foundation/Foundation.h>

@interface SM3Tool : NSObject

//国密算法加密
+(NSString *)sm3Method:(NSString *)password;

@end
