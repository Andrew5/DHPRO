//
//  WTTestObject.mm
//  CollegePro
//
//  Created by jabraknight on 2021/6/19.
//  Copyright © 2021 jabrknight. All rights reserved.
//
#import "WTTestObject.h"
#import "WTTestt.hpp"

using namespace cppdemo;

static WTTestObject *object = nil;
@implementation WTTestObject {
    cppdemo::WTTestt *Tommy;
    cppdemo::WTTestt *Lily;
}
+ (instancetype)installShare{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        object = [[WTTestObject alloc]init];
    });
    return object;
}
- (int)sayHello:(char *)str{
    NSLog(@"c调用OC方法成功");
    return 10;
}
- (void)addTommy {
    Tommy = new cppdemo::WTTestt();
}

- (void)addLily {
    int age = 22;
    NSString *name = @"Lily";
    Lily = new cppdemo::WTTestt(age, [name UTF8String]);
}

- (void)everyBodySayHello {
    Tommy->sayHello();
    Lily->sayHello();
}

@end
int testHelloll (char *str){
    return [[WTTestObject installShare] sayHello:str];
}
