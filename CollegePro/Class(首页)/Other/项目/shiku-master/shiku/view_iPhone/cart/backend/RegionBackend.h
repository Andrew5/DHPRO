//
//  RegionBackend.h
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartBackend.h"
@interface RegionBackend : CartBackend
{
    MBProgressHUD *progressbar;//等待菊花

}
- (RACSignal *)requestRegion:(NSString *)Pid;

@end
