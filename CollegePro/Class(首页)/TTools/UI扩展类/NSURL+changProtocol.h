//
//  NSURL+changProtocol.h
//  JHUniversalApp
//
//  Created by jhwhz on 2016/12/19.
//  Copyright © 2016年  William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (changProtocol)
+ (instancetype)changProtocolURLWithString:(NSString *)URLString;
@end
